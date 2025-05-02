//
// NavigationItemGroup.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container for organizing related navigation items .
public struct NavigationItemGroup: NavigationItem {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public let isPrimitive = true

    /// How a `NavigationBar` displays this item at different breakpoints.
    public var navigationBarVisibility: NavigationBarVisibility = .automatic

    /// The "unstyled" child elements contained within this group.
    private var content: [any NavigationItem]

    /// The child elements contained within this group, with attributes.
    var items: [any NavigationItem] {
        content.map {
            var item = $0
            item.attributes.merge(attributes)
            item.navigationBarVisibility = navigationBarVisibility
            return item
        }
    }

    /// Creates a navigation-item group.
    /// - Parameter items: A closure returning an array of form items to include in the group.
    public init(@ElementBuilder<NavigationItem> items: () -> [any NavigationItem]) {
        self.content = items()
    }

    public func markup() -> Markup {
        items.map { $0.markup() }.joined()
    }
}
