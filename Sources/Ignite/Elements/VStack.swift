//
// VStack.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container that arranges its child elements vertically in a stack.
///
/// - Note: To ensure spacing is consistent, `VStack` strips its subviews of
/// implicit styles, such as the bottom margin automatically applied to paragraphs.
/// All styles explicitly applied through modifiers like `.margin()` will be respected.
public struct VStack: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The spacing between elements.
    private var spacingAmount: SpacingType?

    /// The alignment point for positioning elements within the stack.
    private var alignment: HorizontalAlignment

    /// The child elements contained in the stack.
    private var items: HTMLCollection

    /// Creates a new `Section` object using a block element builder
    /// that returns an array of items to use in this section.
    /// - Parameters:
    ///   - alignment: The horizontal alignment of the subviews.
    ///   - items: The items to use in this section.
    public init(alignment: HorizontalAlignment = .leading, @HTMLBuilder items: () -> some HTML) {
        self.items = HTMLCollection(items)
        self.alignment = alignment
        self.spacingAmount = nil
    }

    /// Creates a new `Section` object using a block element builder
    /// that returns an array of items to use in this section.
    /// - Parameters:
    ///   - pixels: The number of pixels between elements.
    ///   - alignment: The horizontal alignment of the subviews.
    ///   - items: The items to use in this section.
    public init(alignment: HorizontalAlignment = .leading, spacing pixels: Int, @HTMLBuilder items: () -> some HTML) {
        self.items = HTMLCollection(items)
        self.alignment = alignment
        self.spacingAmount = .exact(pixels)
    }

    /// Creates a new `Section` object using a block element builder
    /// that returns an array of items to use in this section.
    /// - Parameters:
    ///   - spacing: The predefined size between elements.
    ///   - alignment: The horizontal alignment of the subviews.
    ///   - items: The items to use in this section.
    public init(alignment: HorizontalAlignment = .leading, spacing: SpacingAmount, @HTMLBuilder items: () -> some HTML) {
        self.items = HTMLCollection(items)
        self.alignment = alignment
        self.spacingAmount = .semantic(spacing)
    }

    public func render() -> String {
        let items = items.elements.map {
            var elementAttributes = CoreAttributes()
            elementAttributes.add(classes: "mb-0")

            switch alignment {
            case .leading:
                elementAttributes.add(styles: .init(.alignSelf, value: "start"))
            case .center:
                elementAttributes.add(styles: .init(.alignSelf, value: "center"))
            case .trailing:
                elementAttributes.add(styles: .init(.alignSelf, value: "end"))
            }

            return $0.attributes(elementAttributes)
        }

        var attributes = attributes
        attributes.add(classes: "vstack")

        switch alignment {
        case .center:
            attributes.add(styles: .init(.textAlign, value: "center"))
        case .trailing:
            attributes.add(styles: .init(.textAlign, value: "end"))
        case .leading:
            break
        }

        if case let .exact(pixels) = spacingAmount {
            attributes.add(styles: .init(.gap, value: "\(pixels)px"))
        } else if case let .semantic(amount) = spacingAmount {
            attributes.add(classes: "gap-\(amount.rawValue)")
        }

        let content = items.map { $0.render() }.joined()
        return "<div\(attributes)>\(content)</div>"
    }
}
