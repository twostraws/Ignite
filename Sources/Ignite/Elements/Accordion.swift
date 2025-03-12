//
// Accordion.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A control that displays a list of section titles that can be folded out to
/// display more content.
public struct Accordion: HTML {
    /// Controls what happens when a section is opened.
    public enum OpenMode: Sendable {
        /// Opening one accordion section automatically closes all others.
        case individual

        /// Users can open multiple sections simultaneously.
        case all
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

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

    /// Creates a new `Accordion` instance from a collection of items, along with a function
    /// that converts a single object from the collection into one item in the accordion.
    /// - Parameters:
    ///   - items: A sequence of items you want to convert into items.
    ///   - content: A function that accepts a single value from the sequence, and
    ///     returns a row representing that value in the accordion.
    public init<T>(_ items: any Sequence<T>, content: (T) -> Item) {
        self.items = items.map(content)
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
    /// - Returns: The HTML for this element.
    public func render() -> String {
        // Accordions with an individual open mode must have
        // each element linked back to a unique accordion ID.
        // This is generated below, then passed into individual
        // items so they can adapt accordinly.
        let accordionID = "accordion\(UUID().uuidString.truncatedHash)"
        let content = Section {
            ForEach(items) { item in
                item.assigned(to: accordionID, openMode: openMode)
            }
        }
        .attributes(attributes)
        .class("accordion")
        .id(accordionID)

        return content.render()
    }
}
