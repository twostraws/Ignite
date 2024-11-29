//
// Modal.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A modal dialog presented on top of the screen
public struct Modal: HTML {
    /// The size of the modal. Except from the full screen modal the height is defined by the height wheras the width
    public enum Size {
        /// A modal dialog with a small max-width of 300px

        case small
        /// A modal dialog with a medium max-width of 500px

        case medium
        /// A modal dialog with a large max-width of 800px

        case large
        /// A modal dialog with an extra large wmax-idth of 1140px

        case xLarge

        /// A fullscreen modal dialog covering the entre view port
        case fullscreen

        /// The HTML name for the modal size.
        var htmlClass: String? {
            switch self {
            case .small:
                "modal-sm"
            case .medium:
                nil
            case .large:
                "modal-lg"
            case .xLarge:
                "modal-xl"
            case .fullscreen:
                "modal-fullscreen"
            }
        }
    }

    public enum Position {
        case top
        case center

        var htmlName: String? {
            switch self {
            case .top:
                nil
            case .center:
                "modal-dialog-centered"
            }
        }
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    let htmlID: String
    private var items: HTMLCollection
    private var header: HTMLCollection
    private var footer: HTMLCollection

    var animated = true
    var scrollable = false
    var size: Size = .medium
    var position: Position = .center

    public init(
        id modalId: String,
        @HTMLBuilder body: () -> some HTML,
        @HTMLBuilder header: () -> some HTML = { EmptyHTML() },
        @HTMLBuilder footer: () -> some HTML = { EmptyHTML() }
    ) {
        self.htmlID = modalId
        self.items = HTMLCollection(body)
        self.header = HTMLCollection(header)
        self.footer = HTMLCollection(footer)
    }

    /// Adjusts the size of the modal.
    /// - Parameter size: The size of the presented modal.
    /// - Returns: A new `Modal` instance with the updated size setting.
    public func size(_ size: Size) -> Self {
        var copy = self
        copy.size = size
        return copy
    }

    /// Adjusts the animation setting for a modal presentation.
    /// - Parameter animated: A boolean value that determines whether the modal presentation should be animated.
    /// - Returns: A new `Modal` instance with the updated animation setting.
    public func animated(_ animated: Bool) -> Self {
        var copy = self
        copy.animated = animated
        return copy
    }

    /// Adjusts the position of the modal view
    /// - Parameter position: The desired vertical position of the modal on the screen.
    /// - Returns: A new `Modal` instance with the updated vertical position.
    public func modalPosition(_ position: Position) -> Self {
        var copy = self
        copy.position = position
        return copy
    }

    /// Determines whether the modal view's content is scrollable.
    /// - Parameter scrollable: A boolean value that determines whether the modal view's content should be scrollable.
    /// - Returns: A new `Modal` instance with the updated scrollable content setting.
    public func scrollableContent(_ scrollable: Bool) -> Self {
        var copy = self
        copy.scrollable = scrollable
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        Group {
            Group {
                Group {
                    if !header.isEmptyHTML {
                        Group {
                            header
                        }
                        .class("modal-header")
                    }

                    Group {
                        items
                    }
                    .class("modal-body")

                    if !footer.isEmptyHTML {
                        Group {
                            footer
                        }
                        .class("modal-footer")
                    }
                }
                .class("modal-content")
            }
            .class("modal-dialog")
            .class(size.htmlClass)
            .class(position.htmlName)
            .class(scrollable ? "modal-dialog-scrollable" : nil)
        }
        .class(animated ? "modal fade" : "modal")
        .tabFocus(.focusable)
        .id(htmlID)
        .aria("labelledby", "modalLabel")
        .aria("hidden", "true")
        .render(context: context)
    }
}
