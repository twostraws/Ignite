//
// ZStack.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Creates a container that stacks its children along the z-axis (depth),
/// with each subsequent child appearing in front of the previous one.
///
/// - Note: To ensure alignment like `.bottom` works as expected,
/// `ZStack` strips its subviews of implicit styles, such as the bottom margin
/// automatically applied to paragraphs. All styles explicitly
/// applied through modifiers like `.margin()` will be respected.
public struct ZStack: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The alignment point for positioning elements within the stack.
    private var alignment: Alignment

    /// The child elements to be stacked.
    private var items: HTMLCollection

    /// Creates a new `ZStack` with the specified alignment and content.
    /// - Parameters:
    ///   - alignment: The point within the stack where elements should be aligned. Defaults `.center`.
    ///   - items: A closure that returns the elements to be stacked.
    public init(alignment: Alignment = .center, @HTMLBuilder _ items: () -> some HTML) {
        self.items = HTMLCollection(items)
        self.alignment = alignment
    }

    public func render() -> String {
        var items = items.elements

        items = items.enumerated().map { index, item in
            var elementAttributes = CoreAttributes()
            elementAttributes.append(classes: "mb-0")
            elementAttributes.append(styles: [
                .init(.position, value: "relative"),
                .init(.gridArea, value: "1/1"),
                .init(.zIndex, value: "\(index)")
            ])

            elementAttributes.append(styles: alignment.itemAlignmentRules)
            return item.attributes(elementAttributes)
        }

        var attributes = attributes
        attributes.append(styles: .init(.display, value: "grid"))

        let content = items.map { $0.render() }.joined()
        return "<div\(attributes)>\(content)</div>"
    }
}
