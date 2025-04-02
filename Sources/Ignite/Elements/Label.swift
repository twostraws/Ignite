//
// Label.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A view that displays an icon and text side by side, with a default
/// spacing of 10 pixels in-between. To adjust the spacing, use `margin()`
/// on either `title` or `icon`.
public struct Label: InlineElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The text content to display alongside the icon.
    private var title: any InlineElement

    /// The icon element to display before the title.
    private var icon: any InlineElement

    /// Creates a label with a string title and image icon.
    /// - Parameters:
    ///   - title: The text to display in the label.
    ///   - path: The image to use as the label's icon.
    public init(_ title: String, image path: String) {
        self.title = title
        self.icon = Image(path, description: title)
    }

    /// Creates a label with a string title and a built-in icon.
    /// - Parameters:
    ///   - title: The text to display in the label.
    ///   - systemImage: An image name chosen from https://icons.getbootstrap.com
    public init(_ title: String, systemImage: String) {
        self.title = title
        self.icon = Image(systemName: systemImage, description: title)
    }

    /// Creates a label with custom title and icon content.
    /// - Parameters:
    ///   - title: A closure that returns the label's text content.
    ///   - icon: A closure that returns the label's icon content.
    public init(
        @InlineElementBuilder title: () -> some InlineElement,
        @InlineElementBuilder icon: () -> some InlineElement
    ) {
        self.title = title()
        self.icon = icon()
    }

    public func render() -> String {
        var icon = icon

        if !icon.attributes.styles.contains(where: { $0.property == Property.marginRight() }) &&
           !title.attributes.styles.contains(where: { $0.property == Property.marginLeft() }) {
            icon.attributes.append(styles: .init(.marginRight, value: "10px"))
        }

        var attributes = attributes
        attributes.append(styles: .init(.display, value: "inline-flex"))
        attributes.append(styles: .init(.alignItems, value: "center"))
        return "<span\(attributes)>\(icon)\(title)</span>"
    }
}
