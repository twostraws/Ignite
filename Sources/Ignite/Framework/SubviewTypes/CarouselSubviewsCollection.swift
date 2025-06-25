//
// CarouselSubviewsCollection.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A collection of carousel subviews that provides random access to carousel elements.
struct CarouselSubviewsCollection: CarouselElement, RandomAccessCollection {
    var body: Never { fatalError() }

    /// Core attributes applied to all elements in the collection.
    var attributes = CoreAttributes()

    /// The carousel subviews contained in this collection.
    nonisolated var elements = [CarouselSubview]()

    /// Creates a collection with the specified carousel subviews.
    /// - Parameter subviews: The carousel subviews to include in the collection.
    init(_ subviews: [CarouselSubview] = []) {
        self.elements = subviews
    }

    /// Creates a collection by flattening the specified carousel element.
    /// - Parameter content: The carousel element to flatten into subviews.
    init(_ content: any CarouselElement) {
        self.elements = flattenedChildren(of: content)
    }

    /// Renders the collection as markup.
    /// - Returns: The rendered markup for all elements in the collection.
    func render() -> Markup {
        elements.map { $0.attributes(attributes).render() }.joined()
    }

    typealias Element = CarouselSubview
    typealias Index = Array<CarouselSubview>.Index

    /// The position of the first element in the collection.
    nonisolated var startIndex: Index { elements.startIndex }

    /// The position one past the last element in the collection.
    nonisolated var endIndex: Index { elements.endIndex }

    /// Returns the element at the specified position.
    /// - Parameter position: The position of the element to access.
    /// - Returns: The carousel subview at the specified position.
    nonisolated subscript(position: Index) -> Element {
        var child = elements[position]
        child.attributes.merge(attributes)
        return child
    }

    // swiftlint:disable identifier_name
    /// Returns the position immediately after the given index.
    /// - Parameter i: The index to advance.
    /// - Returns: The index after the specified position.
    nonisolated func index(after i: Index) -> Index {
        elements.index(after: i)
    }

    /// Returns the position immediately before the given index.
    /// - Parameter i: The index to move backward.
    /// - Returns: The index before the specified position.
    nonisolated func index(before i: Index) -> Index {
        elements.index(before: i)
    }

    /// Returns an index offset by the specified distance.
    /// - Parameters:
    ///   - i: The starting index.
    ///   - distance: The distance to offset the index.
    /// - Returns: The index offset by the specified distance.
    nonisolated func index(_ i: Index, offsetBy distance: Int) -> Index {
        elements.index(i, offsetBy: distance)
    }
    // swiftlint:enable identifier_name

    /// Returns the distance between two indices.
    /// - Parameters:
    ///   - start: The starting index.
    ///   - end: The ending index.
    /// - Returns: The distance between the indices.
    nonisolated func distance(from start: Index, to end: Index) -> Int {
        elements.distance(from: start, to: end)
    }
}

private extension CarouselSubviewsCollection {
    /// Flattens carousel element hierarchies into a collection of subviews.
    /// - Parameter html: The carousel element to flatten.
    /// - Returns: An array of flattened carousel subviews.
    func flattenedChildren<T: CarouselElement>(of html: T) -> [CarouselSubview] {
        var result: [CarouselSubview] = []
        collectFlattenedChildren(html, into: &result)
        return result
    }

    /// Recursively collects carousel subviews from element hierarchies.
    /// - Parameters:
    ///   - html: The carousel element to process.
    ///   - result: The collection to append flattened subviews to.
    func collectFlattenedChildren<T: CarouselElement>(_ html: T, into result: inout [CarouselSubview]) {
        guard let subviewsProvider = html as? any CarouselSubviewsProvider else {
            result.append(CarouselSubview(html))
            return
        }

        for child in subviewsProvider.subviews.elements.map(\.wrapped) {
            collectFlattenedChildren(child, into: &result)
        }
    }
}
