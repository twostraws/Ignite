//
// HStack.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container that arranges its child elements horizontally in a stack.
///
/// - Note: To ensure spacing is consistent, `HStack` strips its subviews of
/// implicit styles, such as the bottom margin automatically applied to paragraphs.
/// All styles explicitly applied via modifiers like `.margin()` will be respected.
public struct HStack: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The spacing between elements.
    private var spacingAmount: SpacingType

    /// The alignment point for positioning elements within the stack.
    private var alignment: VerticalAlignment

    /// The child elements contained in the stack.
    private var items: HTMLCollection

    /// Creates a horizontal stack with the specified alignment, exact pixel spacing, and content.
    /// - Parameters:
    ///   - alignment: The vertical alignment of items within the stack. Defaults to `.center`.
    ///   - pixels: The exact spacing between elements, in pixels.
    ///   - items: A view builder that creates the content of the stack.
    public init(
        alignment: VerticalAlignment = .center,
        spacing pixels: Int,
        @HTMLBuilder items: () -> some HTML
    ) {
        self.items = HTMLCollection(items)
        self.alignment = alignment
        self.spacingAmount = .exact(pixels)
    }

    /// Creates a horizontal stack with the specified alignment, semantic spacing, and content.
    /// - Parameters:
    ///   - alignment: The vertical alignment of items within the stack. Defaults to `.center`.
    ///   - spacing: The semantic spacing between elements. Defaults to `.medium`.
    ///   - items: A view builder that creates the content of the stack.
    public init(
        alignment: VerticalAlignment = .center,
        spacing: SpacingAmount = .medium,
        @HTMLBuilder items: () -> some HTML
    ) {
        self.items = HTMLCollection(items)
        self.alignment = alignment
        self.spacingAmount = .semantic(spacing)
    }

    public func render() -> String {
        let items = items.elements.map {
            var elementAttributes = CoreAttributes()
            elementAttributes.append(classes: "mb-0")
            elementAttributes.append(classes: alignment.itemAlignmentClass)
            return $0.attributes(elementAttributes)
        }

        var attributes = attributes
        attributes.append(classes: "hstack")

        if case let .exact(pixels) = spacingAmount, pixels != 0 {
            attributes.append(styles: .init(.gap, value: "\(pixels)px"))
        } else if case let .semantic(amount) = spacingAmount, amount != .none {
            attributes.append(classes: "gap-\(amount.rawValue)")
        }

        let content = items.map { $0.render() }.joined()
        return "<div\(attributes)>\(content)</div>"
    }
}
