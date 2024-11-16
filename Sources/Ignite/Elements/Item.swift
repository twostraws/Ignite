//
// Item.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// One item inside an accordion.
public struct Item: PageElement {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The title to show for this item. Clicking this title will display the
    /// item's contents.
    var title: any InlineElement

    /// Whether this accordion item should start open or not.
    var startsOpen: Bool

    /// The contents of this accordion item.
    var contents: [BlockElement]

    /// Used when rendering this accordion item so that we can send change
    /// notifications back the parent accordion object.
    var parentID: String?

    /// Used when rendering this accordion item so that we can know whether
    /// opening this item should also close other items.
    var parentOpenMode: Accordion.OpenMode?

    /// Creates a new `Item` object from the provided title and contents.
    /// - Parameters:
    ///   - title: The title to use as the header for this accordion item.
    ///   - startsOpen: Set this to true when this item should be open when
    ///   your page is initially loaded.
    ///   - contents: A block element builder that creates the contents
    ///   for this accordion item.
    public init(
        _ title: any InlineElement,
        startsOpen: Bool = false,
        @BlockElementBuilder contents: () -> [BlockElement]
    ) {
        self.title = title
        self.startsOpen = startsOpen
        self.contents = contents()
    }

    /// Used during rendering to assign this accordion item to a particular parent,
    /// so our open behavior works correctly.
    func assigned(to parentID: String, openMode: Accordion.OpenMode) -> Self {
        var copy = self
        copy.parentID = parentID
        copy.parentOpenMode = openMode
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        guard let parentID, let parentOpenMode else {
            fatalError("Accordion sections must not be rendered without a parentID and parentOpenMode in place.")
        }

        let itemID = "\(parentID)-item\(UUID().uuidString)"

        return Group {
            Text {
                Button(title)
                    .class("accordion-button", startsOpen ? "" : "collapsed")
                    .data("bs-toggle", "collapse")
                    .data("bs-target", "#\(itemID)")
                    .aria("expanded", startsOpen ? "true" : "false")
                    .aria("controls", itemID)
            }
            .font(.title2)
            .class("accordion-header")

            Group {
                Group {
                    contents.render(context: context)
                }
                .class("accordion-body")
            }
            .id(itemID)
            .class("accordion-collapse", "collapse", startsOpen ? "show" : nil)
            .data("bs-parent", parentOpenMode == .individual ? "#\(parentID)" : "")
        }
        .class("accordion-item")
        .render(context: context)
    }
}
