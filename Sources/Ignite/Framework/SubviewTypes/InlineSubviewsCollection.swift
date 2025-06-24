//
// InlineSubviewsCollection.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A collection of inline subviews that can be rendered as HTML markup.
struct InlineSubviewsCollection: InlineElement, RandomAccessCollection {
    var body: Never { fatalError() }

    /// The core attributes applied to all elements in the collection.
    var attributes = CoreAttributes()

    /// The array of inline subviews contained in this collection.
    nonisolated var elements = [InlineSubview]()

    /// Creates a collection from an array of inline subviews.
    /// - Parameter subviews: The subviews to include in the collection.
    init(_ subviews: [InlineSubview] = []) {
        self.elements = subviews
    }

    /// Creates a collection by flattening the children of an inline element.
    /// - Parameter content: The inline element whose children should be flattened.
    init(_ content: any InlineElement) {
        self.elements = flattenedChildren(of: content)
    }

    /// Renders the collection as HTML markup.
    /// - Returns: The rendered markup string.
    func render() -> Markup {
        elements.map { $0.attributes(attributes).render() }.joined()
    }

    // MARK: - RandomAccessCollection Requirements

    typealias Element = InlineSubview
    typealias Index = Array<InlineSubview>.Index

    /// The position of the first element in the collection.
    nonisolated var startIndex: Index { elements.startIndex }

    /// The position one past the last element in the collection.
    nonisolated var endIndex: Index { elements.endIndex }

    /// Accesses the element at the specified position with merged attributes.
    /// - Parameter position: The position of the element to access.
    /// - Returns: The element with merged attributes.
    nonisolated subscript(position: Index) -> Element {
        var child = elements[position]
        child.attributes.merge(attributes)
        return child
    }

    // swiftlint:disable identifier_name
    /// Returns the position immediately after the given index.
    /// - Parameter i: A valid index of the collection.
    /// - Returns: The index immediately after the given index.
    nonisolated func index(after i: Index) -> Index {
        elements.index(after: i)
    }

    /// Returns the position immediately before the given index.
    /// - Parameter i: A valid index of the collection.
    /// - Returns: The index immediately before the given index.
    nonisolated func index(before i: Index) -> Index {
        elements.index(before: i)
    }

    /// Returns an index offset by the given distance from the given index.
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - distance: The distance to offset the index.
    /// - Returns: The index offset by the specified distance.
    nonisolated func index(_ i: Index, offsetBy distance: Int) -> Index {
        elements.index(i, offsetBy: distance)
    }
    // swiftlint:enable identifier_name

    /// Returns the distance between two indices.
    /// - Parameters:
    ///   - start: A valid index of the collection.
    ///   - end: Another valid index of the collection.
    /// - Returns: The distance between the two indices.
    nonisolated func distance(from start: Index, to end: Index) -> Int {
        elements.distance(from: start, to: end)
    }
}

private extension InlineSubviewsCollection {
    /// Returns a flattened array of inline subviews from the given element.
    /// - Parameter html: The inline element to flatten.
    /// - Returns: An array of flattened inline subviews.
    func flattenedChildren<T: InlineElement>(of html: T) -> [InlineSubview] {
        var result: [InlineSubview] = []
        collectFlattenedChildren(html, into: &result)
        return result
    }

    /// Recursively collects flattened children from an inline element.
    /// - Parameters:
    ///   - html: The inline element to process.
    ///   - result: The array to append flattened children to.
    func collectFlattenedChildren<T: InlineElement>(_ html: T, into result: inout [InlineSubview]) {
        guard let subviewsProvider = html as? InlineSubviewsProvider else {
            result.append(InlineSubview(html))
            return
        }

        for child in subviewsProvider.subviews.elements.map(\.wrapped) {
            collectFlattenedChildren(child, into: &result)
        }
    }
}
