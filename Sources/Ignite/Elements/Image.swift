//
// Image.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// An image on your page. Can be vector (SVG) or raster (JPG, PNG, GIF).
public struct Image: BlockElement, InlineElement, LazyLoadable {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// The name of the image to display. This should be specified relative to the
    /// root of your site, e.g. /images/dog.jpg.
    var name: String?
    
    /// An array of alternative formats for the image. Each entry should be a
    /// string representing the path to the alternative image format, relative to the root of your site,
    /// e.g. /images/dog.heic, /images/dog.avif.
    var alternativeFormats: [String]?

    /// Loads an image from one of the built-in icons. See
    /// https://icons.getbootstrap.com for the list.
    var systemImage: String?

    /// An accessibility label for this image, suitable for screen readers.
    var description: String?

    /// Creates a new `Image` instance from the name of an image contained
    /// in your site's assets. This should be specified relative to the root of your
    /// site, e.g. /images/dog.jpg.
    /// - Parameters:
    ///   - name: The filename of your image relative to the root of your site.
    ///   e.g. /images/welcome.jpg.
    ///   - description: An description of your image suitable for screen readers.
    public init(_ name: String, description: String? = nil) {
        self.name = name
        self.description = description
    }
    
    /// Creates a new `Image` instance from the name of an image contained
    /// in your site's assets. This should be specified relative to the root of your
    /// site, e.g. /images/dog.jpg.
    /// - Parameters:
    ///   - name: The filename of your image relative to the root of your site.
    ///   e.g. /images/welcome.jpg.
    ///   - description: A description of your image suitable for screen readers.
    ///   - alternativeFormats: An array of alternative formats for your image. Each format should be specified relative to the root of your site.
    ///
    /// This initializer allows you to create an `Image` instance with both a primary image and multiple alternative formats.
    /// The `alternativeFormats` parameter can be used to provide paths to different versions of the image in modern formats
    /// such as HEIC, AVIF, JXL, and WEBP. This enhances the compatibility and performance of your website by allowing browsers
    /// to choose the most appropriate format they support.
    public init(_ name: String, description: String? = nil, alternativeFormats: [String]) {
        self.name = name
        self.description = description
        self.alternativeFormats = alternativeFormats
    }

    /// Creates a new `Image` instance from the name of one of the built-in
    /// icons. See https://icons.getbootstrap.com for the list.
    /// - Parameters:
    ///   - systemName: An image name chosen from https://icons.getbootstrap.com
    ///   - description: An description of your image suitable for screen readers.
    public init(systemName: String, description: String? = nil) {
        self.systemImage = systemName
        self.description = ""
    }

    /// Creates a new decorative `Image` instance from the name of an
    /// image contained in your site's assets folder. Decorative images are hidden
    /// from screen readers.
    /// - Parameter name: The filename of your image relative to the root
    /// of your site, e.g. /images/dog.jpg.
    public init(decorative name: String) {
        self.name = name
        self.description = ""
    }

    /// Allows this image to be scaled up or down from its natural size in
    /// order to fit into its container.
    /// - Returns: A new `Image` instance configured to be flexibly sized.
    public func resizable() -> Self {
        var copy = self
        copy.attributes.classes.append("img-fluid")
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
    ///   - context: The active publishing context.
    /// - Returns: The HTML for this element.
    private func render(icon: String, description: String, into context: PublishingContext) -> String {
        "<i class=\"bi-\(icon)\"\(attributes.description)></i>"
    }

    /// Renders a user image into the current publishing context.
    /// - Parameters:
    ///   - icon: The user image to render.
    ///   - description: The accessibility label to use.
    ///   - context: The active publishing context.
    /// - Returns: The HTML for this element.
    private func render(image: String, description: String, into context: PublishingContext) -> String {
        """
            <img src=\"\(context.site.url.path)\(image)\" \
            \(attributes.description)\
            alt=\"\(description)\"/>
            """
    }
    
    /// Renders a user image with alternative formats into the current publishing context.
    /// - Parameters:
    ///   - image: The main user image to display.
    ///   - alternativeFormats: An array of strings representing the alternative formats for the image.
    ///   - description: The accessibility label to use.
    ///   - context: The active publishing context.
    /// - Returns: The HTML for this element.
    ///
    /// This method generates an HTML `<picture>` element containing `<source>` elements for
    /// each alternative image format provided, sorted by a predefined priority order. If
    /// the format is not recognized in the priority order, it will be included after the known formats.
    /// The `<img>` element acts as a fallback for browsers that do not support the `<picture>` element.
    private func render(image: String, alternativeFormats: [String], description: String, into context: PublishingContext) -> String {
        // Convert the array of alternative image format strings into a
        // dictionary where the key is the file extension of the each image.
        let availableFormats = alternativeFormats.reduce(into: [String: String]()) { dict, format in
            guard let lastDotIndex = format.lastIndex(of: ".") else { return }
            let fileExtension = String(format[format.index(after: lastDotIndex)...]).lowercased()
            dict[fileExtension] = format
        }
        
        // Define the priority order for modern image formats.
        // * Add more modern formats here if needed.
        let priorityOrder = ["heic", "avif", "jxl", "webp"]
        
        // Create a dictionary to map extensions to their priority indices.
        let priorityIndex = Dictionary(uniqueKeysWithValues: priorityOrder.enumerated().map { ($1, $0) })
        
        // Initialize arrays to hold the sources for known and unknown formats.
        var knownSourcesHTML = [String]()
        var unknownSourcesHTML = [String]()
        let siteUrlPath = context.site.url.path
        
        // Loop through the format dictionary and sort formats based on priority order.
        for (key, value) in availableFormats.sorted(by: {
            let firstIndex = priorityIndex[$0.key] ?? Int.max
            let secondIndex = priorityIndex[$1.key] ?? Int.max
            return firstIndex < secondIndex
        }) {
            let sourceElement = "<source srcset=\"\(siteUrlPath)\(value)\" type=\"image/\(key)\">"
            if priorityIndex.keys.contains(key) {
                knownSourcesHTML.append(sourceElement)
            } else {
                unknownSourcesHTML.append(sourceElement)
            }
        }
        
        let imageRender = render(image: image, description: description, into: context)
        let sourcesRender = (knownSourcesHTML + unknownSourcesHTML).joined(separator: " ")
        
        // Return the complete <picture> element with the sorted <source> elements and the fallback <img> element.
        return "<picture>\(sourcesRender)\(imageRender)</picture>"
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        if description == nil {
            context.addWarning("""
            \(name ?? systemImage ?? "Image"): adding images without a description is not recommended. \
            Provide a description or use Image(decorative:) to silence this warning.
            """)
        }
        
        if let systemImage {
            return render(icon: systemImage, description: description ?? "", into: context)
        } else if let alternativeFormats, !alternativeFormats.isEmpty, let name {
            return render(image: name, alternativeFormats: alternativeFormats, description: description ?? "", into: context)
        } else if let name {
            return render(image: name, description: description ?? "", into: context)
        } else {
            context.addWarning("""
            Creating an image with no name or icon should not be possible. \
            Please file a bug report on the Ignite project.
            """)
            return ""
        }
    }
}
