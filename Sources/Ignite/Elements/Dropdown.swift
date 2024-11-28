//
// Dropdown.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Elements that conform to `DropdownElement` can be shown inside
/// Dropdown objects.
public protocol DropdownElement: InlineHTML {}

/// Renders a button that presents a menu of information when pressed.
/// Can be used as a free-floating element on your page, or in
/// a `NavigationBar`.
public struct Dropdown: BlockHTML, NavigationItem {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// The title for this `Dropdown`.
    var title: any InlineHTML

    /// The array of items to shown in this `Dropdown`.
    var items: [any DropdownElement]

    /// How large this dropdown should be drawn. Defaults to `.medium`.
    var size = ButtonSize.medium

    /// How this dropdown should be styled on the screen. Defaults to `.defaut`.
    var role = Role.default

    /// Controls whether this dropdown needs to be created as its own element,
    /// or whether it uses the structure provided by a parent `NavigationBar`.
    private var isNavigationItem = false

    /// Creates a new dropdown button using a title and an element that builder
    /// that returns an array of types conforming to `DropdownElement`.
    /// - Parameters:
    ///   - title: The title to show on this dropdown button.
    ///   - items: The elements to place inside the dropdown menu.
    public init(
        _ title: any InlineHTML,
        @ElementBuilder<any DropdownElement> items: () -> [any DropdownElement]
    ) {
        self.title = title
        self.items = items()
    }

    /// Adjusts the size of this dropdown.
    /// - Parameter size: The new size.
    /// - Returns: A new `Dropdown` instance with the updated size.
    public func dropdownSize(_ size: ButtonSize) -> Self {
        var copy = self
        copy.size = size
        return copy
    }

    /// Adjusts the role of this dropdown
    /// - Parameter style: The new role.
    /// - Returns: A new `Dropdown` instance with the updated role.
    public func role(_ role: Role) -> Dropdown {
        var copy = self
        copy.role = role
        return copy
    }

    /// Configures this dropdown to be placed inside a `NavigationBar`.
    /// This removes its <div> at render-time, which means it will use the
    /// structure provided directly by the `NavigationBar`.
    /// - Returns: A new `Dropdown` instance suitable for placement
    /// inside a `NavigationBar`.
    func configuredAsNavigationItem() -> Self {
        var copy = self
        copy.isNavigationItem = true
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        Group(isTransparent: isNavigationItem) {
            if isNavigationItem {
                let hasActiveItem = items.contains { context.currentRenderingPath == ($0 as? Link)?.url }

                Link(title, target: "#")
                    .customAttribute(name: "role", value: "button")
                    .class("dropdown-toggle", "nav-link", hasActiveItem ? "active" : nil)
                    .data("bs-toggle", "dropdown")
                    .aria("expanded", "false")
            } else {
                Button(title)
                    .class(Button.classes(forRole: role, size: size))
                    .class("dropdown-toggle")
                    .data("bs-toggle", "dropdown")
                    .aria("expanded", "false")
            }

            List {
                ForEach(items) { item in
                    if let link = item as? Link {
                        ListItem {
                            link.class("dropdown-item")
                                .class(context.currentRenderingPath == link.url ? "active" : nil)
                                .aria("current", context.currentRenderingPath == link.url ? "page" : nil)
                        }
                    } else if let text = item as? Text {
                        ListItem {
                            text.class("dropdown-header")
                        }
                    }
                }
            }
            .listStyle(.unordered(.default))
            .class("dropdown-menu")
        }
        .attributes(attributes)
        .class("dropdown")
        .render(context: context)
    }
}
