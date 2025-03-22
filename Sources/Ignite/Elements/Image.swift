//
// Image.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// An image on your page. Can be vector (SVG) or raster (JPG, PNG, GIF).
public struct Image: InlineElement, LazyLoadable {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The path of the image, either relative to the
    /// root of your site, e.g. /images/dog.jpg., or as a web address.
    var path: URL?

    /// Loads an image from one of the built-in icons. See
    /// https://icons.getbootstrap.com for the list.
    var systemImage: String?

    /// An accessibility label for this image, suitable for screen readers.
    var description: String?

    /// Creates a new `Image` instance from the specified path. For an image contained
    /// in your site's assets, this should be specified relative to the root of your
    /// site, e.g. /images/dog.jpg.
    /// - Parameters:
    ///   - name: The filename of your image relative to the root of your site.
    ///   e.g. /images/welcome.jpg.
    ///   - description: An description of your image suitable for screen readers.
    public init(_ path: String, description: String? = nil) {
        self.path = URL(string: path)
        self.description = description
    }

    /// Creates a new `Image` instance from the name of one of the built-in
    /// icons. See https://icons.getbootstrap.com for the list.
    /// - Parameters:
    ///   - systemName: An image name chosen from https://icons.getbootstrap.com
    ///   - description: An description of your image suitable for screen readers.
    public init(systemName: String, description: String? = nil) {
        self.systemImage = systemName
        self.description = description
    }

    /// Creates a new decorative `Image` instance from the name of an
    /// image contained in your site's assets folder. Decorative images are hidden
    /// from screen readers.
    /// - Parameter name: The filename of your image relative to the root
    /// of your site, e.g. /images/dog.jpg.
    public init(decorative name: String) {
        self.path = URL(string: name)
        self.description = ""
    }

    /// Allows this image to be scaled up or down from its natural size in
    /// order to fit into its container.
    /// - Returns: A new `Image` instance configured to be flexibly sized.
    public func resizable() -> Self {
        var copy = self
        copy.attributes.append(classes: "img-fluid")
        return copy
    }

    /// Sets the accessibility label for this image to a string suitable for
    /// screen readers.
    /// - Parameter label: The new accessibility label to use.
    /// - Returns: A new `Image` instance with the updated accessibility label.
    public func accessibilityLabel(_ label: String) -> Self {
        var copy = self
        copy.description = label
        return copy
    }

    /// Renders a system image into the current publishing context.
    /// - Parameters:
    ///   - icon: The system image to render.
    ///   - description: The accessibility label to use.
    /// - Returns: The HTML for this element.
    private func render(icon: String, description: String) -> String {
        var attributes = attributes
        attributes.append(classes: "bi-\(icon)")
        return "<i\(attributes)></i>"
    }

    /// Renders a user image into the current publishing context.
    /// - Parameters:
    ///   - path: The user image to render.
    ///   - description: The accessibility label to use.
    /// - Returns: The HTML for this element.
    private func render(path: String, description: String) -> String {
        var attributes = attributes
        attributes.append(customAttributes:
            .init(name: "src", value: path),
            .init(name: "alt", value: description))

        let (lightVariants, darkVariants) = findVariants(for: path)

        if let sourceSet = generateSourceSet(lightVariants) {
            attributes.append(customAttributes: sourceSet)
        }

        if darkVariants.isEmpty {
            return "<img\(attributes) />"
        }

        var output = "<picture>"

        if let darkSourceSet = generateSourceSet(darkVariants), let value = darkSourceSet.value {
            output += "<source media=\"(prefers-color-scheme: dark)\" srcset=\"\(value)\">"
        }

        // Add the fallback img tag
        output += "<img\(attributes) />"
        output += "</picture>"
        return output
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        if description == nil {
            publishingContext.addWarning("""
            \(path?.relativePath ?? systemImage ?? "Image"): adding images without a description is not recommended. \
            Provide a description or use Image(decorative:) to silence this warning.
            """)
        }

        if let systemImage {
            return render(icon: systemImage, description: description ?? "")
        } else if let path {
            let resolvedPath = publishingContext.path(for: path)
            return render(path: resolvedPath, description: description ?? "")
        } else {
            publishingContext.addWarning("""
            Creating an image with no name or icon should not be possible. \
            Please file a bug report on the Ignite project.
            """)
            return ""
        }
    }
}

private extension Image {
    /// Checks if a filename contains a pixel density descriptor (e.g., "@2x").
    func isDensityVariant(_ name: String) -> Bool {
        let densityPattern = /.*@\d+x.*/
        return name.contains(densityPattern)
    }

    /// Extracts the pixel density descriptor from a filename (e.g., "2x" from "image@2x.jpg").
    func getDensityDescriptor(_ name: String) -> String? {
        let densityPattern = /@(\d+)x/
        guard let match = name.firstMatch(of: densityPattern) else { return nil }
        return "\(match.output.1)x"
    }

    /// Locates image variants with appearance modifiers (`~dark`) and scale modifiers (`@2x`),
    /// supporting combined modifiers like `@2x~dark`.
    /// - Parameter path: The path to the original image file
    /// - Returns: A tuple containing arrays of URLs for light and dark variants
    func findVariants(for path: String) -> (light: [URL], dark: [URL]) {
        let url = URL(fileURLWithPath: path)
        let assetPath = publishingContext.assetsDirectory.appendingPathComponent(url.deletingLastPathComponent().path)
        let pathExtension = url.pathExtension

        let baseImageName = url.deletingPathExtension().lastPathComponent
            .split(separator: "~").first?
            .split(separator: "@").first ?? ""

        guard let files = try? FileManager.default.contentsOfDirectory(at: assetPath, includingPropertiesForKeys: nil)
            .filter({ $0.pathExtension == pathExtension })
        else {
            publishingContext.addWarning("Could not read the assets directory. Please file a bug report.")
            return ([], [])
        }

        return files.reduce(into: ([URL](), [URL]())) { result, file in
            let filename = file.deletingPathExtension().lastPathComponent
            let baseFilename = filename.split(separator: "~").first?.split(separator: "@").first ?? ""
            guard baseFilename.localizedCaseInsensitiveCompare(baseImageName) == .orderedSame else { return }

            if filename.localizedCaseInsensitiveContains("~dark") {
                result.1.append(file)
            } else if filename.localizedCaseInsensitiveContains("~light") || isDensityVariant(filename) {
                result.0.append(file)
            }
        }
    }

    /// Creates a `srcset` string from image variants with their corresponding pixel density descriptors,
    /// e.g., `"/images/hero@2x.jpg 2x"`
    /// - Parameter variants: An array of image variant URLs
    /// - Returns: An HTML attribute containing the srcset value, or nil if no valid variants exist
    func generateSourceSet(_ variants: [URL]) -> Attribute? {
        let assetsDirectory = publishingContext.assetsDirectory

        let sources = variants.compactMap { variant in
            let filename = variant.deletingPathExtension().lastPathComponent
            let densityDescriptor = getDensityDescriptor(filename).map { " \($0)" } ?? ""
            let relativePath = variant.path.replacingOccurrences(of: assetsDirectory.path, with: "")
            let webPath = relativePath.split(separator: "/").joined(separator: "/")
            return "/\(webPath)\(densityDescriptor)"
        }.joined(separator: ", ")

        return sources.isEmpty ? nil : .init(name: "srcset", value: sources)
    }
}
