//
// Card.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A group of information placed inside a gently rounded
public struct Card: BlockHTML {
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
    public enum ContentPosition: CaseIterable, Sendable {
        public static let allCases: [Card.ContentPosition] = [
            .bottom, .top, .overlay(alignment: .topLeading)
        ]

        /// Positions content below the image.
        case bottom

        /// Positions content above the image.
        case top

        /// Positions content over the image.
        case overlay(alignment: ContentAlignment)

        // Static entries for backward compatibilty
        public static let `default` = Self.bottom
        public static let overlay = Self.overlay(alignment: .topLeading)

        // MARK: Helpers for `render`

        var imageClass: String {
            switch self {
            case .bottom:
                "card-img-top"
            case .top:
                "card-img-bottom"
            case .overlay:
                "card-img"
            }
        }

        var bodyClasses: [String] {
            switch self {
            case .overlay(let alignment):
                ["card-img-overlay", alignment.textAlignment.rawValue, alignment.verticalAlignment.rawValue]
            default:
                ["card-body"]
            }
        }

        var addImageFirst: Bool {
            switch self {
            case .bottom, .overlay:
                true
            case .top:
                false
            }
        }
    }

    enum TextAlignment: String, CaseIterable {
        case start = "text-start"
        case center = "text-center"
        case end = "text-end"
    }

    enum VerticalAlignment: String, CaseIterable {
        case start = "align-content-start"
        case center = "align-content-center"
        case end = "align-content-end"
    }

    public enum ContentAlignment: CaseIterable, Sendable {
        case topLeading
        case top
        case topTrailing
        case leading
        case center
        case trailing
        case bottomLeading
        case bottom
        case bottomTrailing

        var textAlignment: TextAlignment {
            switch self {
            case .topLeading, .leading, .bottomLeading:
                .start
            case .top, .center, .bottom:
                .center
            case .topTrailing, .trailing, .bottomTrailing:
                .end
            }
        }

        var verticalAlignment: VerticalAlignment {
            switch self {
            case .topLeading, .top, .topTrailing:
                .start
            case .leading, .center, .trailing:
                .center
            case .bottomLeading, .bottom, .bottomTrailing:
                .end
            }
        }

        public static let `default` = Self.topLeading
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    var role = Role.default
    var style = CardStyle.default

    var contentPosition = ContentPosition.default
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

    public func render(context: PublishingContext) -> String {
        Group {
            if let image, contentPosition.addImageFirst {
                if imageOpacity != 1 {
                    image
                        .class(contentPosition.imageClass)
                        .style("opacity: \(imageOpacity)")
                } else {
                    image
                        .class(contentPosition.imageClass)
                }
            }

            renderHeader()

            renderItems()

            if let image, !contentPosition.addImageFirst {
                if imageOpacity != 1 {
                    image
                        .class(contentPosition.imageClass)
                        .style("opacity: \(imageOpacity)")
                } else {
                    image
                        .class(contentPosition.imageClass)
                }
            }

            renderFooter()
        }
        .attributes(attributes)
        .class("card")
        .class(cardClasses)
        .render(context: context)
    }

    private func renderHeader() -> Group {
        if header.isEmptyHTML == false {
            return Group {
                for item in header {
                    item
                }
            }
            .class("card-header")
        }
        return Group {}
    }

    private func renderItems() -> Group {
        Group {
            ForEach(items) { item in
                switch item {
                case let text as Text where text.font == .body || text.font == .lead:
                    text.class("card-text")
                case let text as Text:
                    text.class("card-title")
                case let link as Link:
                    link.class("card-link")
                case let image as Image:
                    image.class("card-img")
                default:
                    AnyHTML(item)
                }
            }
        }
        .class(contentPosition.bodyClasses)
    }

    private func renderFooter() -> Group {
        if footer.isEmptyHTML == false {
            return Group {
                for item in footer {
                    item
                }
            }
            .class("card-footer", "text-body-secondary")
        }
        return Group {}
    }
}
