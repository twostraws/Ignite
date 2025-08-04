//
// ControlGroupSubviewsCollection.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A collection that flattens and manages control group subviews.
struct ControlGroupSubviewsCollection: ControlGroupElement, RandomAccessCollection {
    var body: Never { fatalError() }

    /// The core attributes applied to all elements in the collection.
    var attributes = CoreAttributes()

    /// The flattened array of control group subviews.
    nonisolated var elements = [ControlGroupSubview]()

    /// Creates an empty collection.
    init() {}

    /// Creates a collection from control group content.
    /// - Parameter content: The control group element to flatten into subviews.
    init(_ content: any ControlGroupElement) {
        self.elements = flattenedChildren(of: content)
    }

    /// Renders all elements in the collection as markup.
    /// - Returns: The joined markup of all rendered elements.
    func render() -> Markup {
        elements.map { $0.attributes(attributes).render() }.joined()
    }

    // MARK: - RandomAccessCollection Requirements

    /// The element type of the collection.
    typealias Element = ControlGroupSubview
    /// The index type of the collection.
    typealias Index = Array<ControlGroupSubview>.Index

    /// The position of the first element in the collection.
    nonisolated var startIndex: Index { elements.startIndex }

    /// The position one past the last element in the collection.
    nonisolated var endIndex: Index { elements.endIndex }

    /// Accesses the element at the specified position with merged attributes.
    /// - Parameter position: The position of the element to access.
    /// - Returns: The element with merged attributes applied.
    nonisolated subscript(position: Index) -> Element {
        var child = elements[position]
        child.attributes.merge(attributes)
        return child
    }

    /// Returns the position immediately after the given index.
    /// - Parameter i: A valid index of the collection.
    /// - Returns: The index after the given index.
    nonisolated func index(after i: Index) -> Index {
        elements.index(after: i)
    }

    /// Returns the position immediately before the given index.
    /// - Parameter i: A valid index of the collection.
    /// - Returns: The index before the given index.
    nonisolated func index(before i: Index) -> Index {
        elements.index(before: i)
    }

    /// Returns an index offset from the given index by the specified distance.
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - distance: The distance to offset the index.
    /// - Returns: An index offset by the specified distance.
    nonisolated func index(_ i: Index, offsetBy distance: Int) -> Index {
        elements.index(i, offsetBy: distance)
    }

    /// Returns the distance between two indices.
    /// - Parameters:
    ///   - start: A valid index of the collection.
    ///   - end: Another valid index of the collection.
    /// - Returns: The distance between the indices.
    nonisolated func distance(from start: Index, to end: Index) -> Int {
        elements.distance(from: start, to: end)
    }
}

private extension ControlGroupSubviewsCollection {
    /// Flattens a control group element into an array of subviews.
    /// - Parameter html: The control group element to flatten.
    /// - Returns: An array of flattened control group subviews.
    func flattenedChildren<T: ControlGroupElement>(of html: T) -> [ControlGroupSubview] {
        var result: [ControlGroupSubview] = []
        collectFlattenedChildren(html, into: &result)
        return result
    }

    /// Recursively collects flattened children from a control group element.
    /// - Parameters:
    ///   - html: The control group element to process.
    ///   - result: The array to collect flattened children into.
    func collectFlattenedChildren<T: ControlGroupElement>(_ html: T, into result: inout [ControlGroupSubview]) {
        guard let subviewsProvider = html as? ControlGroupSubviewsProvider else {
            result.append(ControlGroupSubview(html))
            return
        }

        for child in subviewsProvider.subviews.elements.map(\.wrapped) {
            collectFlattenedChildren(child, into: &result)
        }
    }
}
