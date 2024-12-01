//
// Image.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// An image on your page. Can be vector (SVG) or raster (JPG, PNG, GIF).
public struct Image: BlockHTML, InlineHTML, LazyLoadable {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// The name of the image to display. This should be specified relative to the
    /// root of your site, e.g. /images/dog.jpg.
    var name: String?

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
        var attributes = attributes
        attributes.append(classes: "bi-\(icon)")
        attributes.tag = "i"
        return attributes.description()
    }

    /// Renders a user image into the current publishing context.
    /// - Parameters:
    ///   - icon: The user image to render.
    ///   - description: The accessibility label to use.
    ///   - context: The active publishing context.
    /// - Returns: The HTML for this element.
    private func render(image: String, description: String, into context: PublishingContext) -> String {
        var attributes = attributes
        attributes.selfClosingTag = "img"
        attributes.append(customAttributes:
            .init(name: "src", value: "\(context.site.url.path)\(image)"),
            .init(name: "alt", value: description)
        )
        return attributes.description()
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
