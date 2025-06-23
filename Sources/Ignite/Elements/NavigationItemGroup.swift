//
// NavigationItemGroup.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container for organizing related navigation items .
public struct NavigationItemGroup: NavigationElement {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public let isPrimitive = true

    /// How a `NavigationBar` displays this item at different breakpoints.
    public var navigationBarVisibility: NavigationBarVisibility = .automatic

    /// The "unstyled" child elements contained within this group.
    private var content: [any NavigationElement]

    /// The child elements contained within this group, with attributes.
    var items: [any NavigationElement] {
        content.map {
            var item = $0
            item.attributes.merge(attributes)
            item.navigationBarVisibility = navigationBarVisibility
            return item
        }
    }

    /// Creates a navigation-item group.
    /// - Parameter items: A closure returning an array of form items to include in the group.
    public init(@ElementBuilder<NavigationElement> items: () -> [any NavigationElement]) {
        self.content = items()
    }

    public func render() -> Markup {
        items.map { $0.render() }.joined()
    }
}
