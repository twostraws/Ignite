//
// AccordionSubviewsCollection.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An opaque element representing the subviews of an `Accordion`.
struct AccordionSubviewsCollection: AccordionElement, RandomAccessCollection {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    /// Core attributes applied to all elements in the collection.
    var attributes = CoreAttributes()

    /// The underlying array of accordion subviews.
    nonisolated var elements = [AccordionSubview]()

    /// Creates a collection with the specified subviews.
    /// - Parameter subviews: An array of accordion subviews.
    init(_ subviews: [AccordionSubview] = []) {
        self.elements = subviews
    }

    /// Creates a collection by flattening the provided accordion element.
    /// - Parameter content: An accordion element to flatten into subviews.
    init(_ content: any AccordionElement) {
        self.elements = flattenedChildren(of: content)
    }

    /// Renders all elements in the collection as markup.
    /// - Returns: The combined markup for all elements.
    func render() -> Markup {
        elements.map { $0.attributes(attributes).render() }.joined()
    }

    typealias Element = AccordionSubview
    typealias Index = Array<AccordionSubview>.Index

    /// The position of the first element in the collection.
    nonisolated var startIndex: Index { elements.startIndex }

    /// The position one past the last element in the collection.
    nonisolated var endIndex: Index { elements.endIndex }

    nonisolated subscript(position: Index) -> Element {
        var child = elements[position]
        child.attributes.merge(attributes)
        return child
    }

    // swiftlint:disable identifier_name
    nonisolated func index(after i: Index) -> Index {
        elements.index(after: i)
    }

    nonisolated func index(before i: Index) -> Index {
        elements.index(before: i)
    }

    nonisolated func index(_ i: Index, offsetBy distance: Int) -> Index {
        elements.index(i, offsetBy: distance)
    }
    // swiftlint:enable identifier_name

    nonisolated func distance(from start: Index, to end: Index) -> Int {
        elements.distance(from: start, to: end)
    }
}

private extension AccordionSubviewsCollection {
    /// Flattens accordion element hierarchies into a collection of subviews.
    /// - Parameter html: The accordion element to flatten.
    /// - Returns: An array of flattened accordion subviews.
    func flattenedChildren<T: AccordionElement>(of html: T) -> [AccordionSubview] {
        var result: [AccordionSubview] = []
        collectFlattenedChildren(html, into: &result)
        return result
    }

    /// Recursively collects accordion subviews from element hierarchies.
    /// - Parameters:
    ///   - html: The accordion element to process.
    ///   - result: The collection to append flattened subviews to.
    func collectFlattenedChildren<T: AccordionElement>(_ html: T, into result: inout [AccordionSubview]) {
        guard let subviewsProvider = html as? any AccordionSubviewsProvider else {
            result.append(AccordionSubview(html))
            return
        }

        for child in subviewsProvider.subviews.elements.map(\.wrapped) {
            collectFlattenedChildren(child, into: &result)
        }
    }
}
