//
// NavigationBar.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Describes elements that can be placed into navigation bars.
public protocol NavigationItem: InlineElement { }

/// A bar that sits across the top of your page to provide top-level navigation
/// throughout your site.
public struct NavigationBar: BlockElement {
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

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// The main logo for your site, such as an image or some text. This becomes
    /// clickable to let users navigate to your homepage.
    let logo: (any InlineElement)?

    /// An array of items to show in this navigation bar.
    let items: [NavigationItem]

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
        @ElementBuilder<NavigationItem> items: () -> [NavigationItem]
    ) {
        self.logo = logo
        self.items = items()
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

                    Group {
                        List {
                            for item in items {
                                if let dropdownItem = item as? Dropdown {
                                    ListItem {
                                        dropdownItem.configuredAsNavigationItem()
                                    }
                                    .class("nav-item", "dropdown")
                                    .data("bs-theme", "light")
                                } else if let link = item as? Link {
                                    ListItem {
                                        let isActive = context.currentRenderingPath == link.url
                                        item
                                            .class("nav-link", isActive ? "active" : nil)
                                            .aria("current", isActive ? "page" : nil)
                                    }
                                    .class("nav-item")
                                } else {
                                    item
                                }
                            }
                        }
                        .class("navbar-nav", "mb-2", "mb-md-0", "col", itemAlignment.rawValue)
                    }
                    .class("collapse", "navbar-collapse")
                    .id("navbarCollapse")
                }
                .class("container-fluid", columnWidth.className)
            }
            .attributes(attributes)
            .class("navbar", "navbar-expand-md")
            .data("bs-theme", theme(for: style))
        }
        .render(context: context)
    }
}
