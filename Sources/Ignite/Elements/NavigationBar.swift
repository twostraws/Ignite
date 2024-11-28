//
// NavigationBar.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Describes elements that can be placed into navigation bars.
public protocol NavigationItem: InlineHTML {}

/// A bar that sits across the top of your page to provide top-level navigation
/// throughout your site.
public struct NavigationBar: BlockHTML {
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

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// Controls the maximum width of the navigation bar content at different breakpoints.
    /// By default, uses Bootstrap's container class.
    private var widthClasses: [String] = ["container"]

    /// The main logo for your site, such as an image or some text. This becomes
    /// clickable to let users navigate to your homepage.
    let logo: (any InlineHTML)?

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
        logo: (any InlineHTML)? = nil
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
        logo: (any InlineHTML)? = nil,
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
        logo: (() -> (any InlineHTML))? = nil
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
    public func width(_ width: Int) -> Self {
        var copy = self
        copy.columnWidth = .count(width)
        if width == .viewport {
            copy.widthClasses = ["container-fluid", columnWidth.className]
        } else {
            copy.widthClasses = ["container", columnWidth.className]
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
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        Tag("header") {
            Tag("nav") {
                Group {
                    if let logo {
                        Link(logo, target: "/")
                            .class("navbar-brand")
                    }
                    renderToggleButton()
                    renderNavItems(context: context)
                }
                .class(widthClasses)
            }
            .attributes(attributes)
            .class("navbar", "navbar-expand-md")
            .data("bs-theme", theme(for: style))
        }
        .render(context: context)
    }

    private func renderToggleButton() -> Button {
        Button {
            Span()
                .class("navbar-toggler-icon")
        }
        .class("navbar-toggler")
        .data("bs-toggle", "collapse")
        .data("bs-target", "#navbarCollapse")
        .aria("controls", "navbarCollapse")
        .aria("expanded", "false")
        .aria("label", "Toggle navigation")
    }

    private func renderNavItems(context: PublishingContext) -> Group {
        Group {
            List {
                ForEach(items) { item in
                    if let dropdownItem = item as? Dropdown {
                        renderDropdownItem(dropdownItem)
                    } else if let link = item as? Link {
                        renderLinkItem(link, context: context)
                    } else {
                        AnyHTML(item)
                    }
                }
            }
            .class("navbar-nav", "mb-2", "mb-md-0", "col", itemAlignment.rawValue)
        }
        .class("collapse", "navbar-collapse")
        .id("navbarCollapse")
    }

    private func renderDropdownItem(_ dropdownItem: Dropdown) -> ListItem {
        ListItem {
            dropdownItem.configuredAsNavigationItem()
        }
        .class("nav-item", "dropdown")
        .data("bs-theme", "light")
    }

    private func renderLinkItem(_ link: Link, context: PublishingContext) -> ListItem {
        ListItem {
            let isActive = context.currentRenderingPath == link.url
            link
                .class("nav-link", isActive ? "active" : nil)
                .aria("current", isActive ? "page" : nil)
        }
        .class("nav-item")
    }
}
