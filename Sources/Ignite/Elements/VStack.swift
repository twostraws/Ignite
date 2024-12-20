//
// VStack.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container that arranges its child elements vertically in a stack.
public struct VStack: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// The vertical space between elements in pixels.
    private var customSpacing: Int?

    /// The vertical space between elements by utility class.
    private var systemSpacing: SpacingAmount?

    /// The child elements contained in the stack.
    private var items: [any HTML]

    /// Creates a new vertical stack with the specified spacing and content.
    /// - Parameters:
    ///   - spacing: The number of pixels between each element. Default is `2`.
    ///   - items: A closure that returns the elements to be arranged vertically.
    public init(spacing: Int = 2, @HTMLBuilder _ items: () -> some HTML) {
        self.items = flatUnwrap(items())
        self.customSpacing = spacing
        self.systemSpacing = nil
    }

    /// Creates a new vertical stack with the specified spacing and content.
    /// - Parameters:
    ///   - spacing: The predefined size between each element. Default is `.small`.
    ///   - items: A closure that returns the elements to be arranged vertically.
    public init(spacing: SpacingAmount = .small, @HTMLBuilder _ items: () -> some HTML) {
        self.items = flatUnwrap(items())
        self.systemSpacing = spacing
        self.customSpacing = nil
    }

    public func render(context: PublishingContext) -> String {
        var itemAttributes = CoreAttributes()
        itemAttributes.append(classes: "mb-0")
        var items = [any HTML]()
        for item in self.items {
            switch item {
            case let container as HTMLCollection:
                for item in container.elements {
                    AttributeStore.default.merge(itemAttributes, intoHTML: item.id)
                    items.append(item)
                }
            default:
                AttributeStore.default.merge(itemAttributes, intoHTML: item.id)
                items.append(item)
            }
        }

        var attributes = attributes
        attributes.append(classes: "vstack")
        attributes.append(styles:
            .init(name: "display", value: "block"),
            .init(name: "width", value: "100%")
        )
        if let customSpacing {
            attributes.append(styles: .init(name: .gap, value: "\(customSpacing)px"))
        } else if let systemSpacing {
            attributes.append(classes: "gap-\(systemSpacing.rawValue)")
        }

        AttributeStore.default.merge(attributes, intoHTML: id)
        attributes.tag = "div"
        let content = items.map { $0.render(context: context) }.joined()
        return attributes.description(wrapping: content)
    }
}
