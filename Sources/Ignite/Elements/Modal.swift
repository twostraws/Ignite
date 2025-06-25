//
// Modal.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modal dialog presented on top of the screen
public struct Modal<Header: HTML, Footer: HTML, Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    private let htmlID: String
    private var content: Content
    private var header: Header
    private var footer: Footer

    private var animated = true
    private var scrollable = false
    private var size: ModalSize = .medium
    private var position: ModalPosition = .center

    /// Creates a new modal dialog with the specified content.
    /// - Parameters:
    ///   - modalId: A unique identifier for the modal.
    ///   - body: The main content of the modal.
    ///   - header: Optional header content for the modal.
    ///   - footer: Optional footer content for the modal.
    public init(
        id modalId: String,
        @HTMLBuilder content: () -> Content,
        @HTMLBuilder header: () -> Header = { EmptyHTML() },
        @HTMLBuilder footer: () -> Footer = { EmptyHTML() }
    ) {
        self.htmlID = modalId
        self.content = content()
        self.header = header()
        self.footer = footer()
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
                    if !header.isEmptyHTML {
                        Section(header)
                            .class("modal-header")
                    }

                    Section(content)
                        .class("modal-body")

                    if !footer.isEmptyHTML {
                        Section(footer)
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
