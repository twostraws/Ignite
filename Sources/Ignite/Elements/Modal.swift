//
// Modal.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modal dialog presented on top of the screen
public struct Modal: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    let htmlID: String
    private var items: HTMLCollection
    private var header: HTMLCollection
    private var footer: HTMLCollection

    var animated = true
    var scrollable = false
    var size: ModalSize = .medium
    var position: ModalPosition = .center

    public init(
        id modalId: String,
        @HTMLBuilder body: () -> some BodyElement,
        @HTMLBuilder header: () -> some BodyElement = { EmptyHTML() },
        @HTMLBuilder footer: () -> some BodyElement = { EmptyHTML() }
    ) {
        self.htmlID = modalId
        self.items = HTMLCollection([body()])
        self.header = HTMLCollection([header()])
        self.footer = HTMLCollection([footer()])
    }

    /// Adjusts the size of the modal.
    /// - Parameter size: The size of the presented modal.
    /// - Returns: A new `Modal` instance with the updated size setting.
    public func size(_ size: ModalSize) -> Self {
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
    public func modalPosition(_ position: ModalPosition) -> Self {
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
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        Section {
            Section {
                Section {
                    if !header.isEmpty {
                        Section {
                            header
                        }
                        .class("modal-header")
                    }

                    Section {
                        items
                    }
                    .class("modal-body")

                    if !footer.isEmpty {
                        Section {
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
        .aria(.labelledBy, "modalLabel")
        .aria(.hidden, "true")
        .render()
    }
}
