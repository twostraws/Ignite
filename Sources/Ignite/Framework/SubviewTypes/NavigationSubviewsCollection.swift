//
// NavigationSubviewsCollection.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A collection of navigation subviews that flattens hierarchical navigation elements.
struct NavigationSubviewsCollection: HTML, RandomAccessCollection {
    var body: some HTML { self }

    var attributes = CoreAttributes()

    nonisolated var elements = [NavigationSubview]()

    /// Creates a collection by flattening the children of a navigation element.
    /// - Parameter child: The navigation element to flatten.
    init(_ child: any NavigationElement) {
        self.elements = flattenedChildren(of: child)
    }

    /// Creates an empty collection.
    init() {
        self.elements = []
    }

    /// Renders all elements in the collection as markup.
    /// - Returns: The joined markup from all rendered elements.
    func render() -> Markup {
        elements.map { $0.render() }.joined()
    }

    typealias Element = NavigationSubview
    typealias Index = Array<NavigationSubview>.Index

    nonisolated var startIndex: Index { elements.startIndex }
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

private extension NavigationSubviewsCollection {
    /// Flattens the hierarchy of a navigation element into an array of subviews.
    /// - Parameter html: The navigation element to flatten.
    /// - Returns: An array of flattened navigation subviews.
    func flattenedChildren<T: NavigationElement>(of html: T) -> [NavigationSubview] {
        var result: [NavigationSubview] = []
        collectFlattenedChildren(html, into: &result)
        return result
    }

    /// Recursively collects flattened children from a navigation element.
    /// - Parameters:
    ///   - html: The navigation element to process.
    ///   - result: The array to collect flattened children into.
    func collectFlattenedChildren<T: NavigationElement>(_ html: T, into result: inout [NavigationSubview]) {
        guard let subviewsProvider = html as? NavigationSubviewsProvider else {
            result.append(NavigationSubview(html))
            return
        }

        for child in subviewsProvider.children.elements.map(\.wrapped) {
            collectFlattenedChildren(child, into: &result)
        }
    }
}
