//
// GroupBox.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public struct GroupBox: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    var items: [any HTML] = []
    private var backgroundColor: Color?

    public init(background: Color? = nil, @HTMLBuilder content: () -> some HTML) {
        self.items = flatUnwrap(content())
        self.backgroundColor = background
    }

    public init(_ items: any HTML, background: Color? = nil) {
        self.items = flatUnwrap(items)
        self.backgroundColor = background
    }

    init(context: PublishingContext, items: [any HTML]) {
        self.items = flatUnwrap(items)
        self.backgroundColor = nil
    }

    public func render(context: PublishingContext) -> String {
        let content = items.map { $0.render(context: context) }.joined()
        var attributes = attributes
        attributes.tag = "div"

        if let backgroundColor {
            attributes.append(styles: .init(name: "background-color", value: backgroundColor.description))
        }

        return attributes.description(wrapping: content)
    }
}
