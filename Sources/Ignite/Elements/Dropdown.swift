//
// DropdownItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Elements that conform to `DropdownItem` can be shown inside
/// Dropdown objects.
public protocol DropdownItem: BodyElement {}

/// Renders a button that presents a menu of information when pressed.
/// Can be used as a free-floating element on your page, or in
/// a `NavigationBar`.
public struct Dropdown: HTML, NavigationElement, FormItem {
    /// How the dropdown should be rendered based on its context.
    enum Configuration: Sendable {
        /// Renders as a complete standalone dropdown.
        case standalone
        /// Renders for placement inside a navigation bar.
        case navigationBarItem
        /// Renders for placement inside a control group.
        case controlGroupItem
        /// Renders as the last item in a control group with special positioning.
        case lastControlGroupItem
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How a `NavigationBar` displays this item at different breakpoints.
    public var navigationBarVisibility: NavigationBarVisibility = .automatic

    /// The title for this `Dropdown`.
    private var title: any InlineElement

    /// The array of items to shown in this `Dropdown`.
    private var items: [any DropdownItem]

    /// How large this dropdown should be drawn. Defaults to `.medium`.
    private var size = Button.Size.medium

    /// How this dropdown should be styled on the screen. Defaults to `.defaut`.
    private var role = Role.default

    /// Controls whether this dropdown needs to be created as its own element,
    /// or whether it uses the structure provided by a parent like `NavigationBar`.
    private var configuration: Configuration = .standalone

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

    /// Sets how this dropdown should be rendered based on its placement context.
    /// - Parameter configuration: The context in which this dropdown will be used.
    /// - Returns: A configured dropdown instance.
    func configuration(_ configuration: Configuration) -> Self {
        var copy = self
        copy.configuration = configuration
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        if configuration == .standalone {
            Section(renderDropdownContent())
                .attributes(attributes)
                .class("dropdown")
                .render()
        } else {
            renderDropdownContent()
                .attributes(attributes)
                .render()
        }
    }

    /// Creates the internal dropdown structure including the trigger button and menu items.
    /// - Returns: A group containing the dropdown's trigger and menu list.
    @HTMLBuilder
    private func renderDropdownContent() -> some BodyElement {
        if configuration == .navigationBarItem {
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
        .class(configuration == .lastControlGroupItem ? "dropdown-menu-end" : nil)
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
