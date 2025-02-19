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

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The alignment point for positioning elements within the stack.
    private var alignment: Alignment

    /// The child elements to be stacked.
    private var items: [any HTML] = []

    /// Creates a new ZStack with the specified alignment and content.
    /// - Parameters:
    ///   - alignment: The point within the stack where elements should be aligned (default: .center).
    ///   - items: A closure that returns the elements to be stacked.
    public init(alignment: Alignment = .center, @HTMLBuilder _ items: () -> some HTML) {
        self.items = flatUnwrap(items())
        self.alignment = alignment
    }

    public func render() -> String {
        var items = [any HTML]()

        for item in self.items {
            if let container = item as? HTMLCollection {
                items.append(contentsOf: container.elements)
            } else {
                items.append(item)
            }
        }

        items.enumerated().forEach { index, item in
            var elementAttributes = CoreAttributes()

            elementAttributes.append(styles: [
                .init(.position, value: "relative"),
                .init(.display, value: "grid"),
                .init(.gridArea, value: "1/1"),
                .init(.zIndex, value: "\(index)"),
                .init(.marginBottom, value: "0")
            ])

            elementAttributes.append(styles: alignment.flexAlignmentRules)

            AttributeStore.default.merge(elementAttributes, intoHTML: item.id)
        }

        var attributes = attributes
        attributes.append(styles: [
            .init(.position, value: "relative"),
            .init(.width, value: "100%"),
            .init(.display, value: "grid")
        ])

        AttributeStore.default.merge(attributes, intoHTML: id)
        attributes.tag = "div"

        let content = items.map { $0.render() }.joined()
        return attributes.description(wrapping: content)
    }
}

fileprivate extension Alignment {
    /// Flex container rules for aligning content
    var flexAlignmentRules: [InlineStyle] {
        switch (horizontal, vertical) {
        case (.leading, .top):      [.init(.justifyContent, value: "flex-start"), .init(.alignItems, value: "flex-start")]
        case (.center, .top):       [.init(.justifyContent, value: "center"), .init(.alignItems, value: "flex-start")]
        case (.trailing, .top):     [.init(.justifyContent, value: "flex-end"), .init(.alignItems, value: "flex-start")]
        case (.leading, .center):   [.init(.justifyContent, value: "flex-start"), .init(.alignItems, value: "center")]
        case (.center, .center):    [.init(.justifyContent, value: "center"), .init(.alignItems, value: "center")]
        case (.trailing, .center):  [.init(.justifyContent, value: "flex-end"), .init(.alignItems, value: "center")]
        case (.leading, .bottom):   [.init(.justifyContent, value: "flex-start"), .init(.alignItems, value: "flex-end")]
        case (.center, .bottom):    [.init(.justifyContent, value: "center"), .init(.alignItems, value: "flex-end")]
        case (.trailing, .bottom):  [.init(.justifyContent, value: "flex-end"), .init(.alignItems, value: "flex-end")]
        }
    }
}
