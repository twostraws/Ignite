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
    ///   - image: The image to use as the label's icon.
    public init(_ title: String, image: Image) {
        self.title = title
        self.icon = image
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
        var title = title

        if !(title is String) {
            title.attributes.add(classes: "mb-0")
        }

        var icon = icon

        if !(icon is String) {
            icon.attributes.add(classes: "mb-0")
        }

        if !icon.attributes.styles.contains(where: { $0.property == Property.marginRight() }) &&
           !title.attributes.styles.contains(where: { $0.property == Property.marginLeft() }) {
            icon.attributes.add(styles: .init(.marginRight, value: "10px"))
        }

        var attributes = attributes
        attributes.add(styles: .init(.display, value: "inline-flex"))
        attributes.add(styles: .init(.alignItems, value: "center"))
        return "<span\(attributes)>\(icon)\(title)</span>"
    }
}
