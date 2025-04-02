//
// NavigationBar.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Describes elements that can be placed into navigation bars.
public protocol NavigationItem: HTML {}

/// A bar that sits across the top of your page to provide top-level navigation
/// throughout your site.
public struct NavigationBar: HTML {
    /// The color scheme for this navigation bar.
    public enum NavigationBarStyle {
        /// No specific color scheme means this bar will be rendered using
        /// automatic settings.
        case `default`

        /// This bar must always be rendered in light mode.
        case light

        /// This bar must always be rendered in dark mode.
        case dark
    }

    /// The new number of columns to use.
    public enum Width: Sendable {
        /// Viewport sets column width
        case viewport
        /// Specific count sets column width
        case count(Int)
    }

    /// How navigation bar items should be aligned horizontally.
    public enum ItemAlignment: String {
        /// Items are aligned to the leading edge by default.
        case `default` = ""

        /// Items are aligned in the center
        case center = "justify-content-center"

        /// Items are aligned to the trailing edge
        case trailing = "justify-content-end"
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// Controls the maximum width of the navigation bar content at different breakpoints.
    /// By default, uses Bootstrap's container class.
    private var widthClasses: [String] = ["container"]

    /// The main logo for your site, such as an image or some text. This becomes
    /// clickable to let users navigate to your homepage.
    let logo: (any InlineElement)?

    /// An array of items to show in this navigation bar.
    let items: [any NavigationItem]

    /// The style to use when rendering this bar.
    var style = NavigationBarStyle.default

    /// How items in this navigation bar should be aligned
    var itemAlignment = ItemAlignment.default

    /// Creates a new `NavigationBar` instance from the `logo`, without any items.
    /// - Parameters:
    ///   - logo: The logo to use in the top-left edge of your bar.
    public init(
        logo: (any InlineElement)? = nil
    ) {
        self.logo = logo
        self.items = []
    }

    /// Creates a new `NavigationBar` instance from the `logo` and
    /// `items` provided.
    /// - Parameters:
    ///   - logo: The logo to use in the top-left edge of your bar.
    ///   - items: An element builder that returns an array of
    /// `NavigationItem` objects.
    public init(
        logo: (any InlineElement)? = nil,
        @ElementBuilder<NavigationItem> items: () -> [any NavigationItem]
    ) {
        self.logo = logo
        self.items = items()
    }

    /// Creates a new `NavigationBar` instance from the `logo` and
    /// `items` provided.
    /// - Parameters:
    ///   - items: An element builder that returns an array of
    /// `NavigationItem` objects.
    ///   - logo: The logo to use in the top-left edge of your bar.
    public init(
        @ElementBuilder<NavigationItem> items: () -> [any NavigationItem],
        logo: (() -> (any InlineElement))? = nil
    ) {
        self.items = items()
        self.logo = logo?()
    }

    /// Adjusts the style of this navigation bar.
    /// - Parameter style: The new style.
    /// - Returns: A new `NavigationBar` instance with the updated style.
    public func navigationBarStyle(_ style: NavigationBarStyle) -> Self {
        var copy = self
        copy.style = style
        return copy
    }

    /// Adjusts the number of columns assigned to the items in the navigation bar.
    /// It does not have an effect on the navigation bar itself.
    /// - Parameter width: The new number of columns to use.
    /// - Returns: A new `NavigationBar` instance with the adjusted column width.
    public func width(_ width: Width) -> Self {
        var copy = self
        switch width {
        case .viewport:
            copy.widthClasses = ["container-fluid", copy.columnWidth]
        case .count(let count):
            copy.columnWidth(.count(count))
            copy.widthClasses = ["container", copy.columnWidth]
        }
        return copy
    }

    /// Adjusts the item alignment for this navigation bar.
    /// - Parameter alignment: The new alignment.
    /// - Returns: A new `NavigationBar` instance with the updated item alignment.
    public func navigationItemAlignment(_ alignment: ItemAlignment) -> Self {
        var copy = self
        copy.itemAlignment = alignment
        return copy
    }

    func theme(for style: NavigationBarStyle) -> String? {
        switch style {
        case .default: nil
        case .light: "light"
        case .dark: "dark"
        }
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        Tag("header") {
            Tag("nav") {
                Section {
                    if let logo {
                        renderLogo(logo)
                    }
                    if !items.isEmpty {
                        renderToggleButton()
                        renderNavItems()
                    }
                }
                .class(widthClasses)
            }
            .attributes(attributes)
            .class("navbar", "navbar-expand-md")
            .data("bs-theme", theme(for: style))
        }
        .render()
    }

    private func renderToggleButton() -> some InlineElement {
        Button {
            Span()
                .class("navbar-toggler-icon")
        }
        .class("navbar-toggler")
        .data("bs-toggle", "collapse")
        .data("bs-target", "#navbarCollapse")
        .aria(.controls, "navbarCollapse")
        .aria(.expanded, "false")
        .aria(.label, "Toggle navigation")
    }

    private func renderNavItems() -> some HTML {
        Section {
            List {
                ForEach(items.filter { !($0 is Span) }) { item in
                    switch item {
                    case let dropdownItem as Dropdown:
                        renderDropdownItem(dropdownItem)
                    case let link as Link:
                        renderLinkItem(link)
                    default:
                        AnyHTML(item)
                    }
                }
            }
            .class("navbar-nav", "mb-2", "mb-md-0", "col", itemAlignment.rawValue)

            ForEach(items.compactMap { $0 as? Span }) { text in
                renderTextItem(text)
            }
        }
        .class("collapse", "navbar-collapse")
        .id("navbarCollapse")
    }

    private func renderDropdownItem(_ dropdownItem: Dropdown) -> some HTML {
        ListItem {
            dropdownItem.configuredAsNavigationItem()
        }
        .class("nav-item", "dropdown")
    }

    private func renderLinkItem(_ link: Link) -> some HTML {
        ListItem {
            let isActive = publishingContext.currentRenderingPath == link.url
            link.trimmingMargin() // Remove the default margin applied to text
                .class(link.style == .button ? nil : "nav-link")
                .class(isActive ? "active" : nil)
                .aria(.current, isActive ? "page" : nil)
        }
        .class("nav-item")
    }

    private func renderTextItem(_ text: Span) -> some InlineElement {
        var text = text
        text.attributes.append(classes: "navbar-text")
        return text
    }

    private func renderLogo(_ logo: any InlineElement) -> some InlineElement {
        Link(logo, target: "/")
            .trimmingMargin()
            .class("navbar-brand")
    }
}

fileprivate extension Link {
    func trimmingMargin() -> Self {
        guard content.isText else { return self }
        var link = self
        var text = content
        text.attributes.append(classes: "mb-0")
        link.content = text
        return link
    }
}

fileprivate extension HTML {
    /// Adds a data attribute to the element.
    /// - Parameters:
    ///   - name: The name of the data attribute
    ///   - value: The value of the data attribute
    /// - Returns: The modified `HTML` element
    func data(_ name: String, _ value: String?) -> Self {
        guard let value else { return self }
        var copy = self
        copy.attributes.append(dataAttributes: .init(name: name, value: value))
        return copy
    }
}
