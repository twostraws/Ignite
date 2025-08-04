//
// SubviewsCollection.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A collection of HTML subviews that can be rendered and accessed randomly.
struct SubviewsCollection: HTML, RandomAccessCollection {
    var body: Never { fatalError() }

    /// Core HTML attributes applied to all elements in the collection.
    var attributes = CoreAttributes()

    /// The underlying array of subview elements.
    nonisolated var elements = [Subview]()

    /// Creates a collection from an array of subviews.
    /// - Parameter children: The subviews to include in the collection.
    init(_ children: [Subview] = []) {
        self.elements = children
    }

    /// Creates a collection from an array of HTML elements.
    /// - Parameter children: The HTML elements to convert to subviews.
    init(_ children: [any HTML] = []) {
        self.elements = children.map(Subview.init)
    }

    /// Creates a collection by flattening the children of an HTML element.
    /// - Parameter content: The HTML element whose children should be flattened.
    init(_ content: any HTML) {
        self.elements = flattenedChildren(of: content)
    }

    /// Renders all elements in the collection to markup.
    /// - Returns: The rendered markup for all elements.
    func render() -> Markup {
        elements.map { $0.attributes(attributes).render() }.joined()
    }

    // MARK: - RandomAccessCollection Requirements

    typealias Element = Subview
    typealias Index = Array<Subview>.Index

    /// The position of the first element in the collection.
    nonisolated var startIndex: Index { elements.startIndex }

    /// The position one past the last element in the collection.
    nonisolated var endIndex: Index { elements.endIndex }

    /// Accesses the element at the specified position.
    /// - Parameter position: The position of the element to access.
    /// - Returns: The element at the specified position with merged attributes.
    nonisolated subscript(position: Index) -> Element {
        var child = elements[position]
        child.attributes.merge(attributes)
        return child
    }

    /// Returns the position immediately after the given index.
    /// - Parameter i: The index to advance.
    /// - Returns: The index after the given index.
    nonisolated func index(after i: Index) -> Index {
        elements.index(after: i)
    }

    /// Returns the position immediately before the given index.
    /// - Parameter i: The index to move backward from.
    /// - Returns: The index before the given index.
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

    /// Returns the distance between two indices.
    /// - Parameters:
    ///   - start: The starting index.
    ///   - end: The ending index.
    /// - Returns: The distance between the two indices.
    nonisolated func distance(from start: Index, to end: Index) -> Int {
        elements.distance(from: start, to: end)
    }
}

private extension SubviewsCollection {
    /// Recursively flattens all child elements of an HTML element into a single array.
    /// - Parameter html: The HTML element to flatten.
    /// - Returns: An array of flattened subviews.
    func flattenedChildren<T: HTML>(of html: T) -> [Subview] {
        var result: [Subview] = []
        collectFlattenedChildren(html, into: &result)
        return result
    }

    /// Recursively collects flattened children from an HTML element.
    /// - Parameters:
    ///   - html: The HTML element to process.
    ///   - result: The array to collect flattened children into.
    func collectFlattenedChildren<T: HTML>(_ html: T, into result: inout [Subview]) {
        guard let subviewsProvider = html as? any SubviewsProvider else {
            result.append(Subview(html))
            return
        }

        for child in subviewsProvider.subviews.elements.map(\.wrapped) {
            collectFlattenedChildren(child, into: &result)
        }
    }
}
