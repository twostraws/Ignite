//
// Accordion.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A control that displays a list of section titles that can be folded out to
/// display more content.
public struct Accordion: BlockHTML {
    /// Controls what happens when a section is opened.
    public enum OpenMode {
        /// Opening one accordion section automatically closes all others.
        case individual

        /// Users can open multiple sections simultaneously.
        case all
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// A collection of sections you want to show inside this accordion.
    var items: [Item]

    /// Adjusts what happens when a section is opened.
    /// Defaults to `.individual`, meaning that only one
    /// accordion section may be open at a time.
    private var openMode = OpenMode.individual

    /// Create a new Accordion from a collection of sections.
    /// - Parameter items: A result builder containing all the sections
    /// you want to display in this accordion.
    public init(@ElementBuilder<Item> _ items: () -> [Item]) {
        self.items = items()
    }

    /// Adjusts the open mode for this Accordion.
    /// - Parameter mode: The new open mode.
    /// - Returns: A copy of this Accordion with the new open mode set.
    public func openMode(_ mode: OpenMode) -> Self {
        var copy = self
        copy.openMode = mode
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        // Accordions with an individual open mode must have
        // each element linked back to a unique accordion ID.
        // This is generated below, then passed into individual
        // items so they can adapt accordinly.
        let accordionID = "accordion\(UUID().uuidString)"
        let assignedItems = items.map { $0.assigned(to: accordionID, openMode: openMode) }
        let output = Group { assignedItems }
            .attributes(attributes)
            .class("accordion")
            .id(accordionID)
            .render(context: context)

        return output
    }
}
