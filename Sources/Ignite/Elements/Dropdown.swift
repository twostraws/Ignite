//
// DropdownItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Elements that conform to `DropdownItem` can be shown inside
/// Dropdown objects.
public protocol DropdownItem: HTML {}

/// Renders a button that presents a menu of information when pressed.
/// Can be used as a free-floating element on your page, or in
/// a `NavigationBar`.
public struct Dropdown: HTML, NavigationItem {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The title for this `Dropdown`.
    var title: any InlineElement

    /// The array of items to shown in this `Dropdown`.
    var items: [any DropdownItem]

    /// How large this dropdown should be drawn. Defaults to `.medium`.
    var size = Button.Size.medium

    /// How this dropdown should be styled on the screen. Defaults to `.defaut`.
    var role = Role.default

    /// Controls whether this dropdown needs to be created as its own element,
    /// or whether it uses the structure provided by a parent `NavigationBar`.
    private var isNavigationItem = false

    /// Creates a new dropdown button using a title and an element that builder
    /// that returns an array of types conforming to `DropdownItem`.
    /// - Parameters:
    ///   - title: The title to show on this dropdown button.
    ///   - items: The elements to place inside the dropdown menu.
    public init(
        _ title: any InlineElement,
        @ElementBuilder<any DropdownItem> items: () -> [any DropdownItem]
    ) {
        self.title = title
        self.items = items()
    }

    /// Creates a new dropdown button using a title and an element that builder
    /// that returns an array of types conforming to `DropdownItem`.
    /// - Parameters:
    ///   - items: The elements to place inside the dropdown menu.
    ///   - title: The title to show on this dropdown button.
    public init(
        @ElementBuilder<any DropdownItem> items: () -> [any DropdownItem],
        @InlineElementBuilder title: () -> any InlineElement
    ) {
        self.items = items()
        self.title = title()
    }

    /// Adjusts the size of this dropdown.
    /// - Parameter size: The new size.
    /// - Returns: A new `Dropdown` instance with the updated size.
    public func dropdownSize(_ size: Button.Size) -> Self {
        var copy = self
        copy.size = size
        return copy
    }

    /// Adjusts the role of this dropdown
    /// - Parameter role: The new role.
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
    /// - Returns: The HTML for this element.
    public func render() -> String {
        if isNavigationItem {
            Group(renderDropdownContent())
                .attributes(attributes)
                .class("dropdown")
                .render()
        } else {
            Section(renderDropdownContent())
                .attributes(attributes)
                .class("dropdown")
                .render()
        }
    }

    /// Creates the internal dropdown structure including the trigger button and menu items.
    /// - Returns: A group containing the dropdown's trigger and menu list.
    private func renderDropdownContent() -> some HTML {
        Group {
            if isNavigationItem {
                let titleAttributes = title.attributes
                let title = title.clearingAttributes()
                let hasActiveItem = items.contains {
                    publishingContext.currentRenderingPath == ($0 as? Link)?.url
                }

                Link(title, target: "#")
                    .customAttribute(name: "role", value: "button")
                    .class("dropdown-toggle", "nav-link", hasActiveItem ? "active" : nil)
                    .data("bs-toggle", "dropdown")
                    .aria(.expanded, "false")
                    .attributes(titleAttributes)
            } else {
                Button(title)
                    .class(Button.classes(forRole: role, size: size))
                    .class("dropdown-toggle")
                    .data("bs-toggle", "dropdown")
                    .aria(.expanded, "false")
            }

            List {
                ForEach(items) { item in
                    if let link = item as? Link {
                        ListItem {
                            link.class("dropdown-item")
                                .class(publishingContext.currentRenderingPath == link.url ? "active" : nil)
                                .aria(.current, publishingContext.currentRenderingPath == link.url ? "page" : nil)
                        }
                    } else if let text = item as? Text {
                        ListItem {
                            text.class("dropdown-header")
                        }
                    }
                }
            }
            .listMarkerStyle(.unordered(.automatic))
            .class("dropdown-menu")
        }
    }
}

private extension InlineElement {
    /// Returns a copy of the element with all attributes removed.
    func clearingAttributes() -> some InlineElement {
        var copy = self
        copy.attributes = CoreAttributes()
        return copy
    }
}
