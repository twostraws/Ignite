//
// DropdownItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type for elements that have different configurations
/// when places in a `Dropdown`.
@MainActor
protocol DropdownItemConfigurable {
    var configuration: DropdownConfiguration { get set }
}

/// Renders a button that presents a menu of information when pressed.
/// Can be used as a free-floating element on your page, or in
/// a `NavigationBar`.
public struct Dropdown<Label: InlineElement, Content: HTML>: HTML, NavigationElement, ControlGroupElement {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The title for this `Dropdown`.
    private var title: Label

    /// The array of items to shown in this `Dropdown`.
    private var content: Content

    /// How large this dropdown should be drawn. Defaults to `.medium`.
    private var size = ButtonSize.medium

    /// How this dropdown should be styled on the screen. Defaults to `.defaut`.
    private var role = Role.default

    /// The color of the dropdown's label.
    private var labelColor: Color?

    /// Controls whether this dropdown needs to be created as its own element,
    /// or whether it uses the structure provided by a parent like `NavigationBar`.
    var configuration = DropdownConfiguration.standalone

    /// Creates a new dropdown button using a title and an element that builder
    /// that returns an array of types conforming to `DropdownItem`.
    /// - Parameters:
    ///   - title: The title to show on this dropdown button.
    ///   - items: The elements to place inside the dropdown menu.
    public init<C>(
        _ title: Label,
        @DropdownElementBuilder items: () -> C
    ) where Content == DropdownElementBuilder.Content<C>, C: DropdownElement {
        self.title = title
        self.content = DropdownElementBuilder.Content(items())
    }

    /// Creates a new dropdown button using a title and an element that builder
    /// that returns an array of types conforming to `DropdownItem`.
    /// - Parameters:
    ///   - items: The elements to place inside the dropdown menu.
    ///   - title: The title to show on this dropdown button.
    public init<C>(
        @DropdownElementBuilder items: () -> C,
        @InlineElementBuilder title: () -> Label
    ) where Content == DropdownElementBuilder.Content<C>, C: DropdownElement {
        self.title = title()
        self.content = DropdownElementBuilder.Content(items())
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
    /// - Parameter role: The new role.
    /// - Returns: A new `Dropdown` instance with the updated role.
    public func role(_ role: Role) -> Dropdown {
        var copy = self
        copy.role = role
        return copy
    }

    /// Sets the color of the dropdown's label.
    /// - Parameter color: The color to apply to the dropdown label.
    /// - Returns: A modified dropdown with the specified label color.
    public func labelColor(_ color: Color) -> Self {
        var copy = self
        copy.labelColor = color
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

    /// Returns the title attributes with optional color styling applied.
    /// - Returns: A `CoreAttributes` instance containing the title's
    /// attributes with optional color styling.
    private func titleAttributes() -> CoreAttributes {
        var attributes = title.attributes
        if let labelColor {
            let color = labelColor.description
            attributes.append(styles: .init("--bs-nav-link-color", value: color))
            attributes.append(styles: .init("--bs-nav-link-hover-color", value: color))
            attributes.append(styles: .init("--bs-navbar-active-color", value: color))
        }
        return attributes
    }

    /// Creates the internal dropdown structure including the trigger button and menu items.
    /// - Returns: A group containing the dropdown's trigger and menu list.
    @HTMLBuilder private func renderDropdownContent() -> some HTML {
        if configuration == .navigationBarItem {
            let titleAttributes = titleAttributes()
            let title = title.clearingAttributes()

            Link(title, target: "#")
                .customAttribute(name: "role", value: "button")
                .class("dropdown-toggle", "nav-link")
                .data("bs-toggle", "dropdown")
                .aria(.expanded, "false")
                .attributes(titleAttributes)
        } else {
            Button(title)
                .class(size.classes(forRole: role))
                .class("dropdown-toggle")
                .data("bs-toggle", "dropdown")
                .aria(.expanded, "false")
        }

        List {
            content
        }
        .listMarkerStyle(.unordered(.automatic))
        .class("dropdown-menu")
        .class(configuration == .lastControlGroupItem ? "dropdown-menu-end" : nil)
    }
}

extension Dropdown: DropdownItemConfigurable {
    /// Sets how this dropdown should be rendered based on its placement context.
    /// - Parameter configuration: The context in which this dropdown will be used.
    /// - Returns: A configured dropdown instance.
    func configuration(_ configuration: DropdownConfiguration) -> Self {
        var copy = self
        copy.configuration = configuration
        return copy
    }
}

extension Dropdown: NavigationElementRenderable {
    func renderAsNavigationElement() -> Markup {
        var copy = ListItem(self.configuration(.navigationBarItem))
        copy.attributes.append(classes: "nav-item", "dropdown")
        copy.attributes.append(styles: .init(.listStyleType, value: "none"))
        return copy.render()
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
