//
// Card.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A group of information placed inside a gently rounded
public struct Card: BlockElement {
    public enum CardStyle: CaseIterable {
        case `default`, `solid`, `bordered`
    }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    var role = Role.default
    var style = CardStyle.default

    var image: Image?
    var header = [any PageElement]()
    var footer = [any PageElement]()
    var items: [any PageElement]

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
        @PageElementBuilder body: () -> [PageElement],
        @PageElementBuilder header: () -> [PageElement] = { [] },
        @PageElementBuilder footer: () -> [PageElement] = { [] }
    ) {
        if let imageName {
            self.image = Image(decorative: imageName)
        }

        self.header = header()
        self.footer = footer()
        self.items = body()
    }

    public func role(_ role: Role) -> Card {
        var copy = self
        copy.role = role

        if self.style == .default {
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

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        Group {
            if let image {
                image
                    .class("card-img-top")
            }

            if header.isEmpty == false {
                Group {
                    for item in header {
                        item
                    }
                }
                .class("card-header")
            }

            Group {
                for item in items {
                    switch item {
                    case let textItem as Text:
                        switch textItem.resolvedFont {
                        case .body, .lead:
                            item.class("card-text")
                        default:
                            item.class("card-title")
                        }
                    case is Link:
                        item.class("card-link")
                    default:
                        item
                    }
                }
            }
            .class("card-body")

            if footer.isEmpty == false {
                Group {
                    for item in footer {
                        item
                    }
                }
                .class("card-footer", "text-body-secondary")
            }
        }
        .attributes(attributes)
        .class("card")
        .class(cardClasses)
        .render(context: context)
    }
}
