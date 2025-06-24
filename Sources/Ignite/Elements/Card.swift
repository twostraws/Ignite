//
// Card.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that provides a specialized configuration
/// when displayed within a card container.
@MainActor
protocol CardComponentConfigurable {
    /// Returns the original element, configured for display
    /// within in a `Card`, in an opaque wrapper.
    func configuredAsCardComponent() -> CardComponent
}

/// A group of information placed inside a gently rounded
public struct Card: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    var role = Role.default
    var style = CardStyle.default

    var contentPosition = CardContentPosition.default
    var imageOpacity = 1.0

    var image: Image?
    private var header: HTMLCollection
    private var footer: HTMLCollection
    private var items: HTMLCollection

    var cardClasses: String? {
        switch style {
        case .default:
            nil
        case .solid:
            "text-bg-\(role.rawValue)"
        case .bordered:
            "border-\(role.rawValue)"
        }
    }

    public init(
        imageName: String? = nil,
        @HTMLBuilder body: () -> some HTML,
        @HTMLBuilder header: () -> some HTML = { EmptyHTML() },
        @HTMLBuilder footer: () -> some HTML = { EmptyHTML() }
    ) {
        if let imageName {
            self.image = Image(decorative: imageName)
        }

        self.header = HTMLCollection(header)
        self.footer = HTMLCollection(footer)
        self.items = HTMLCollection(body)
    }

    public func role(_ role: Role) -> Card {
        var copy = self
        copy.role = role

        if style == .default {
            copy.style = .solid
        }

        return copy
    }

    /// Adjusts the rendering style of this card.
    /// - Parameter style: The new card style to use.
    /// - Returns: A new `Card` instance with the updated style.
    public func cardStyle(_ style: CardStyle) -> Card {
        var copy = self
        copy.style = style
        return copy
    }

    /// Adjusts the position of this card's content relative to its image.
    /// - Parameter newPosition: The new content positio for this card.
    /// - Returns: A new `Card` instance with the updated content position.
    public func contentPosition(_ newPosition: CardContentPosition) -> Self {
        var copy = self
        copy.contentPosition = newPosition
        return copy
    }

    /// Adjusts the opacity of the image for this card. Use values
    /// lower than 1.0 to progressively dim the image.
    /// - Parameter opacity: The new opacity for this card.
    /// - Returns: A new `Card` instance with the updated image opacity.
    public func imageOpacity(_ opacity: Double) -> Self {
        var copy = self
        copy.imageOpacity = opacity
        return copy
    }

    public func render() -> Markup {
        Section {
            if let image, contentPosition.addImageFirst {
                if imageOpacity != 1 {
                    image
                        .class(contentPosition.imageClass)
                        .style(.opacity, imageOpacity.description)
                } else {
                    image
                        .class(contentPosition.imageClass)
                }
            }

            if header.isEmptyHTML == false {
                renderHeader()
            }

            renderItems()

            if let image, !contentPosition.addImageFirst {
                if imageOpacity != 1 {
                    image
                        .class(contentPosition.imageClass)
                        .style(.opacity, imageOpacity.description)
                } else {
                    image
                        .class(contentPosition.imageClass)
                }
            }

            if footer.isEmptyHTML == false {
                renderFooter()
            }
        }
        .attributes(attributes)
        .class("card")
        .class(cardClasses)
        .render()
    }

    private func renderHeader() -> some HTML {
        Section(header)
            .class("card-header")
    }

    private func renderItems() -> some HTML {
        Section {
            ForEach(items) { item in
                switch item {
                case let text as Text where text.font == .body || text.font == .lead:
                    text.class("card-text")
                case let text as Text:
                    text.class("card-title")
                case is Link, is LinkGroup:
                    AnyHTML(item).class("card-link")
                case let image as Image:
                    image.class("card-img")
                default:
                    AnyHTML(item)
                }
            }
        }
        .class(contentPosition.bodyClasses)
    }

    private func renderFooter() -> some HTML {
        Section(footer)
            .class("card-footer", "text-body-secondary")
    }
}
