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
            var elementAttributes = ElementDescriptor()
            elementAttributes.append(styles: [
                .init(.position, value: "relative"),
                .init(.display, value: "grid"),
                .init(.gridArea, value: "1/1"),
                .init(.zIndex, value: "\(index)"),
                .init(.marginBottom, value: "0")
            ])

            elementAttributes.append(styles: alignment.flexAlignmentRules)

            DescriptorStorage.shared.merge(elementAttributes, intoHTML: item.id)
        }

        var attributes = descriptor
        attributes.append(styles: .init(.display, value: "grid"))

        DescriptorStorage.shared.merge(attributes, intoHTML: id)
        attributes.tag = "div"

        let content = items.map { $0.render() }.joined()
        return attributes.description(wrapping: content)
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
