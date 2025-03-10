//
// VStack.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container that arranges its child elements vertically in a stack.
public struct VStack: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The spacing between elements.
    private var spacingAmount: SpacingType?

    /// The child elements contained in the stack.
    private var content: HTMLCollection

    /// Whether the `VStack` should ignore its subviews' implicit
    /// styles, like the bottom margins paragraphs.
    private var shouldNormalizeSubviews: Bool = false

    /// Creates a new `Section` object using a block element builder
    /// that returns an array of items to use in this section.
    /// - Parameter items: The items to use in this section.
    public init(@HTMLBuilder items: () -> some HTML) {
        self.content = HTMLCollection(items)
        self.spacingAmount = nil
    }

    /// Creates a new `Section` object using a block element builder
    /// that returns an array of items to use in this section.
    /// - Parameters:
    ///   - pixels: The number of pixels between elements.
    ///   - normalizeSubviews: Whether the `VStack` should ignore its subviews' implicit
    /// styles, like the bottom margins paragraphs.
    ///   - items: The items to use in this section.
    public init(
        spacing pixels: Int,
        normalizeSubviews: Bool = false,
        @HTMLBuilder items: () -> some HTML
    ) {
        self.shouldNormalizeSubviews = normalizeSubviews
        self.content = HTMLCollection(items)
        self.spacingAmount = .exact(pixels)
    }

    /// Creates a new `Section` object using a block element builder
    /// that returns an array of items to use in this section.
    /// - Parameters:
    ///   - spacing: The predefined size between elements.
    ///   - normalizeSubviews: Whether the `VStack` should ignore its subviews' implicit
    /// styles, like the bottom margins paragraphs.
    ///   - items: The items to use in this section.
    public init(spacing: SpacingAmount, normalizeSubviews: Bool = false, @HTMLBuilder items: () -> some HTML) {
        self.shouldNormalizeSubviews = normalizeSubviews
        self.content = HTMLCollection(items)
        self.spacingAmount = .semantic(spacing)
    }

    public func render() -> String {
        var content = content
        if shouldNormalizeSubviews, !content.attributes.setsBottomMargin {
            content.attributes.add(classes: "mb-0")
        }

        var attributes = attributes
        attributes.add(classes: "vstack")

        if case let .exact(pixels) = spacingAmount {
            attributes.add(styles: .init(.gap, value: "\(pixels)px"))
        } else if case let .semantic(amount) = spacingAmount {
            attributes.add(classes: "gap-\(amount.rawValue)")
        }

        return "<div\(attributes)>\(content)</div>"
    }
}

extension CoreAttributes {
    var setsBottomMargin: Bool {
        styles.contains(where: { $0.property == Property.marginBottom.rawValue }) ||
        classes.contains(where: { className in
            className.range(
                of: "\\b(m|my|mb)-([0-9]|[1-5]|auto|n[1-5])\\b",
                options: .regularExpression) != nil
        })
    }
}
