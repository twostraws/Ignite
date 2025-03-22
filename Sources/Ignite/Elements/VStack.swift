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

    /// Creates a container that stacks its subviews vertically.
    /// - Parameters:
    ///   - alignment: The horizontal alignment of items within the stack. Defaults to `.center`.
    ///   - pixels: The exact spacing between elements in pixels.
    ///   Pass `nil` to preserve implicit margins. Defaults to `0`.
    ///   - items: A view builder that creates the content of the stack.
    public init(
        alignment: HorizontalAlignment = .center,
        spacing pixels: Int? = 0,
        @HTMLBuilder items: () -> some HTML
    ) {
        self.items = HTMLCollection(items)
        self.alignment = .responsive(alignment)
        if let pixels {
            self.spacingAmount = .exact(pixels)
        }
    }

    /// Creates a container that stacks its subviews vertically.
    /// - Parameters:
    ///   - alignment: The horizontal alignment of items within the stack. Defaults to `.center`.
    ///   - spacing: The predefined size between each element.
    ///   - items: A view builder that creates the content of the stack.
    public init(
        alignment: HorizontalAlignment = .center,
        spacing: SpacingAmount,
        @HTMLBuilder items: () -> some HTML
    ) {
        self.items = HTMLCollection(items)
        self.alignment = .responsive(alignment)
        self.spacingAmount = .semantic(spacing)
    }

    /// Creates a container that stacks its subviews vertically.
    /// - Parameters:
    ///   - alignment: The responsive horizontal alignment of items that can vary across breakpoints.
    ///   - pixels: The exact spacing between elements in pixels.
    ///   Pass `nil` to preserve implicit margins. Defaults to `0`.
    ///   - items: A view builder that creates the content of the stack.
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

    /// Creates a container that stacks its subviews vertically.
    /// - Parameters:
    ///   - alignment: The responsive horizontal alignment of items that can vary across breakpoints.
    ///   - spacing: The predefined size between each element.
    ///   - items: A view builder that creates the content of the stack.
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

        if case let .exact(pixels) = spacingAmount, pixels != 0 {
            attributes.append(styles: .init(.gap, value: "\(pixels)px"))
        } else if case let .semantic(amount) = spacingAmount {
            attributes.append(classes: "gap-\(amount.rawValue)")
        }

        let content = items.map { $0.render() }.joined()
        return "<div\(attributes)>\(content)</div>"
    }
}
