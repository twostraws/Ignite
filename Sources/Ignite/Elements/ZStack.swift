//
// ZStack.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Creates a container that stacks its children along the z-axis (depth),
/// with each subsequent child appearing in front of the previous one.
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

    /// Whether the `ZStack` should ignore any margins automatically
    /// applied to its children, like the bottom margin of a paragraph.
    private var shouldIgnoreMargins: Bool = false

    /// Creates a new ZStack with the specified alignment and content.
    /// - Parameters:
    ///   - alignment: The point within the stack where elements should be aligned (default: .center).
    ///   - ignoreMargins: Whether the `VStack` should ignore any margins automatically
    /// applied to its children, like the bottom margin of a paragraph.
    ///   - items: A closure that returns the elements to be stacked.
    public init(
        alignment: Alignment = .center,
        ignoreMargins: Bool = false,
        @HTMLBuilder _ items: () -> some HTML
    ) {
        self.items = HTMLCollection(items)
        self.alignment = alignment
    }

    public func render() -> String {
        var items = items.elements

        items = items.enumerated().map { index, item in
            var elementAttributes = CoreAttributes()
            elementAttributes.add(styles: [
                .init(.position, value: "relative"),
                .init(.display, value: "grid"),
                .init(.gridArea, value: "1/1"),
                .init(.zIndex, value: "\(index)")
            ])

            if shouldIgnoreMargins {
                elementAttributes.add(classes: "mb-0")
            }

            elementAttributes.add(styles: alignment.flexAlignmentRules)
            return item.attributes(elementAttributes)
        }

        var attributes = attributes
        attributes.add(styles: .init(.display, value: "grid"))

        let content = items.map { $0.render() }.joined()
        return "<div\(attributes)>\(content)</div>"
    }
}

fileprivate extension Alignment {
    /// Grid container rules for aligning content
    var flexAlignmentRules: [InlineStyle] {
        switch (horizontal, vertical) {
        case (.leading, .top):      [.init(.alignSelf, value: "flex-start"), .init(.justifySelf, value: "flex-start")]
        case (.center, .top):       [.init(.alignSelf, value: "flex-start"), .init(.justifySelf, value: "center")]
        case (.trailing, .top):     [.init(.alignSelf, value: "flex-start"), .init(.justifySelf, value: "flex-end")]
        case (.leading, .center):   [.init(.alignSelf, value: "center"), .init(.justifySelf, value: "flex-start")]
        case (.center, .center):    [.init(.alignSelf, value: "center"), .init(.justifySelf, value: "center")]
        case (.trailing, .center):  [.init(.alignSelf, value: "center"), .init(.justifySelf, value: "flex-end")]
        case (.leading, .bottom):   [.init(.alignSelf, value: "flex-end"), .init(.justifySelf, value: "flex-start")]
        case (.center, .bottom):    [.init(.alignSelf, value: "flex-end"), .init(.justifySelf, value: "center")]
        case (.trailing, .bottom):  [.init(.alignSelf, value: "flex-end"), .init(.justifySelf, value: "flex-end")]
        }
    }
}
