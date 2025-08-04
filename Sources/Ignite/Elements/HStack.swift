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
public struct HStack<Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The spacing between elements.
    private var spacingAmount: SpacingAmount

    /// The alignment point for positioning elements within the stack.
    private var alignment: VerticalAlignment

    /// The child elements contained in the stack.
    private var children: SubviewsCollection

    /// Creates a horizontal stack with the specified alignment, exact pixel spacing, and content.
    /// - Parameters:
    ///   - alignment: The vertical alignment of items within the stack. Defaults to `.center`.
    ///   - pixels: The exact spacing between elements, in pixels.
    ///   - items: A view builder that creates the content of the stack.
    public init(
        alignment: VerticalAlignment = .center,
        spacing pixels: Int,
        @HTMLBuilder content: () -> Content
    ) {
        self.children = SubviewsCollection(content())
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
        spacing: SemanticSpacing = .medium,
        @HTMLBuilder content: () -> Content
    ) {
        self.children = SubviewsCollection(content())
        self.alignment = alignment
        self.spacingAmount = .semantic(spacing)
    }

    public func render() -> Markup {
        let items: [any HTML] = children.map {
            var elementAttributes = CoreAttributes()
            elementAttributes.append(classes: "mb-0")
            elementAttributes.append(classes: alignment.itemAlignmentClass)
            if let provider = $0.wrapped as? any SpacerProvider {
                return Subview(provider.spacer.axis(.horizontal))
            }
            return $0.attributes(elementAttributes)
        }

        var attributes = attributes
        attributes.append(classes: "hstack")

        if case let .exact(pixels) = spacingAmount, pixels != 0 {
            attributes.append(styles: .init(.gap, value: "\(pixels)px"))
        } else if case let .semantic(amount) = spacingAmount, amount != .none {
            attributes.append(classes: "gap-\(amount.rawValue)")
        }

        let contentHTML = items.map { $0.markupString() }.joined()
        return Markup("<div\(attributes)>\(contentHTML)</div>")
    }
}
