//
// Item.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that inherits data from a containing `Accordion`.
@MainActor
protocol AccordionItemAssignable: AccordionElement {
    func assigned(to parentID: String, openMode: AccordionOpenMode) -> Self
}

/// One item inside an accordion.
public struct Item<Header: InlineElement, Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The title to show for this item. Clicking this title will display the
    /// item's contents.
    private var title: Header

    /// Whether this accordion item should start open or not.
    private var startsOpen: Bool

    /// The contents of this accordion item.
    private var content: Content

    /// Used when rendering this accordion item so that we can send change
    /// notifications back the parent accordion object.
    private var parentID: String?

    /// The background color of the accordion item content.
    private var contentBackground: Color?

    /// Used when rendering this accordion item so that we can know whether
    /// opening this item should also close other items.
    private var parentOpenMode: AccordionOpenMode?

    /// Creates a new `Item` object from the provided title and contents.
    /// - Parameters:
    ///   - header: The title to use as the header for this accordion item.
    ///   - startsOpen: Set this to true when this item should be open when
    ///   your page is initially loaded.
    ///   - content: A block element builder that creates the contents
    ///   for this accordion item.
    public init(
        _ header: Header,
        startsOpen: Bool = false,
        @HTMLBuilder content: () -> Content
    ) {
        self.title = header
        self.startsOpen = startsOpen
        self.content = content()
    }

    /// Creates a new `Item` object from the provided title and contents.
    /// - Parameters:
    ///   - startsOpen: Set this to true when this item should be open when
    ///   your page is initially loaded.
    ///   - content: A block element builder that creates the contents
    ///   for this accordion item.
    ///   - header: An inline element builder that creates the title to use
    ///   as the header for this accordion item.
    public init(
        startsOpen: Bool = false,
        @HTMLBuilder content: () -> Content,
        @InlineElementBuilder header: () -> Header
    ) {
        self.startsOpen = startsOpen
        self.content = content()
        self.title = header()
    }

    /// Sets the background color for the accordion item's content area.
    /// - Parameter color: The color to use for the content background.
    /// - Returns: A modified copy of this accordion item.
    public func contentBackground(_ color: Color) -> Self {
        var copy = self
        copy.contentBackground = color
        return copy
    }

    /// Used during rendering to assign this accordion item to a particular parent,
    /// so our open behavior works correctly.
    func assigned(to parentID: String, openMode: AccordionOpenMode) -> Self {
        var copy = self
        copy.parentID = parentID
        copy.parentOpenMode = openMode
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        guard let parentID, let parentOpenMode else {
            fatalError("Accordion sections must not be rendered without a parentID and parentOpenMode in place.")
        }

        let itemID = "\(parentID)-item\(UUID().uuidString.truncatedHash)"

        return Section {
            Text {
                Button(title)
                    .class("accordion-button", startsOpen ? nil : "collapsed")
                    .data("bs-toggle", "collapse")
                    .data("bs-target", "#\(itemID)")
                    .aria(.expanded, startsOpen ? "true" : "false")
                    .aria(.controls, itemID)
            }
            .font(.title2)
            .class("accordion-header")

            Section {
                Section(content)
                    .class("accordion-body")
            }
            .id(itemID)
            .class("accordion-collapse", "collapse", startsOpen ? "show" : nil)
            .data("bs-parent", parentOpenMode == .individual ? "#\(parentID)" : "")
            .style(contentBackground == nil ? nil : .init(.background, value: contentBackground!.description))
        }
        .class("accordion-item")
        .render()
    }
}

extension Item: AccordionElement {}

extension Item: AccordionItemAssignable {}
