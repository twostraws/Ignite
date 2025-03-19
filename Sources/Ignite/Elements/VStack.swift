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
/// To retain these implicit styles, set `spacing` to `nil`.
public struct VStack: HTML {
    /// A type that represents spacing values in either exact pixels or semantic spacing amounts.
    private enum SpacingType: Equatable {
        case exact(Int), semantic(SpacingAmount)
    }

    /// Adaptive spacing amounts that are used by Bootstrap to provide consistency
    /// in site design.
    public enum SpacingAmount: Int, CaseIterable, Sendable {
        case xSmall = 1
        case small
        case medium
        case large
        case xLarge
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The spacing between elements.
    private var spacingAmount: SpacingType?

    /// The alignment point for positioning elements within the stack.
    private var alignment: HorizontalAlignment.ResponsiveAlignment

    /// The child elements contained in the stack.
    private var items: HTMLCollection

    /// Creates a new `Section` object using a block element builder
    /// that returns an array of items to use in this section.
    /// - Parameters:
    ///   - pixels: The number of pixels between elements. Defaults to `0.`
    ///   - alignment: The horizontal alignment of the subviews.
    ///   - items: The items to use in this section.
    public init(
        alignment: HorizontalAlignment = .leading,
        spacing pixels: Int? = 0,
        @HTMLBuilder items: () -> some HTML
    ) {
        self.items = HTMLCollection(items)
        self.alignment = .responsive(alignment)
        if let pixels {
            self.spacingAmount = .exact(pixels)
        }
    }

    /// Creates a new `Section` object using a block element builder
    /// that returns an array of items to use in this section.
    /// - Parameters:
    ///   - spacing: The predefined size between elements.
    ///   - alignment: The horizontal alignment of the subviews.
    ///   - items: The items to use in this section.
    public init(
        alignment: HorizontalAlignment = .leading,
        spacing: SpacingAmount,
        @HTMLBuilder items: () -> some HTML
    ) {
        self.items = HTMLCollection(items)
        self.alignment = .responsive(alignment)
        self.spacingAmount = .semantic(spacing)
    }

    /// Creates a new `Section` object using a block element builder
    /// that returns an array of items to use in this section.
    /// - Parameters:
    ///   - pixels: The number of pixels between elements. Defaults to `0.`
    ///   - alignment: The responsive horizontal alignment of the subviews.
    ///   - items: The items to use in this section.
    public init(
        alignment: HorizontalAlignment.ResponsiveAlignment,
        spacing pixels: Int? = 0,
        @HTMLBuilder items: () -> some HTML
    ) {
        self.items = HTMLCollection(items)
        self.alignment = alignment
        if let pixels {
            self.spacingAmount = .exact(pixels)
        }
    }

    /// Creates a new `Section` object using a block element builder
    /// that returns an array of items to use in this section.
    /// - Parameters:
    ///   - spacing: The predefined size between elements.
    ///   - alignment: The responsive horizontal alignment of the subviews.
    ///   - items: The items to use in this section.
    public init(
        alignment: HorizontalAlignment.ResponsiveAlignment,
        spacing: SpacingAmount,
        @HTMLBuilder items: () -> some HTML
    ) {
        self.items = HTMLCollection(items)
        self.alignment = alignment
        self.spacingAmount = .semantic(spacing)
    }

    public func render() -> String {
        let items = items.elements.map {
            var elementAttributes = CoreAttributes()
            if spacingAmount != nil {
                elementAttributes.append(classes: "mb-0")
            }
            elementAttributes.append(classes: alignment.itemAlignmentClasses)
            return $0.attributes(elementAttributes)
        }

        var attributes = attributes
        attributes.append(classes: "vstack")

        if alignment != .responsive(.leading) {
            attributes.append(classes: alignment.containerAlignmentClasses)
        }

        if case let .exact(pixels) = spacingAmount, pixels != 0 {
            attributes.appending(styles: .init(.gap, value: "\(pixels)px"))
        } else if case let .semantic(amount) = spacingAmount {
            attributes.append(classes: "gap-\(amount.rawValue)")
        }

        let content = items.map { $0.render() }.joined()
        return "<div\(attributes)>\(content)</div>"
    }
}
