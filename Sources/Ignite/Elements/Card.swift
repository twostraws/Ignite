//
// Card.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A group of information placed inside a gently rounded
public struct Card: BlockElement {
    /// Styling for this card.
    public enum CardStyle: CaseIterable {
        /// Default styling.
        case `default`

        /// Solid background color.
        case solid

        /// Solid border color.
        case bordered
    }

    /// Where to position the content of the card relative to it image.
    public enum ContentPosition: String, CaseIterable {
        /// Positions content below the image.
        case bottom = "card-img-top"

        /// Positions content above the image.
        case top = "card-img-bottom"

        /// Positions content over the image.
        case overlay = "card-img-overlay"

        public static let `default` = Self.bottom

        var imageClass: String {
            self == .overlay ? "card-img" : rawValue
        }

        var bodyClass: String {
            self == .overlay ? rawValue : "card-body"
        }
    }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    var role = Role.default
    var style = CardStyle.default

    var contentPosition = ContentPosition.default
    var imageOpacity = 1.0

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

    /// Adjusts the position of this card's content relative to its image.
    /// - Parameter newPosition: The new content positio for this card.
    /// - Returns: A new `Card` instance with the updated content position.
    public func contentPosition(_ newPosition: ContentPosition) -> Self {
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

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        Group {
            if let image, contentPosition != .top {
                if imageOpacity != 1 {
                    image
                        .class(contentPosition.imageClass)
                        .style("opacity: \(imageOpacity)")
                } else {
                    image
                        .class(contentPosition.imageClass)
                }
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
                        switch textItem.font {
                        case .body, .lead:
                            item.class("card-text")
                        default:
                            item.class("card-title")
                        }
                    case is Link:
                        item.class("card-link")
                    case is Image:
                        item.class("card-img")
                    default:
                        item
                    }
                }
            }
            .class(contentPosition.bodyClass)

            if let image, contentPosition == .top {
                if imageOpacity != 1 {
                    image
                        .class(contentPosition.imageClass)
                        .style("opacity: \(imageOpacity)")
                } else {
                    image
                        .class(contentPosition.imageClass)
                }
            }

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
