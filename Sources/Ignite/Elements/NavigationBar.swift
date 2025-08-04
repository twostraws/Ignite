//
// NavigationBar.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A bar that sits across the top of your page to provide top-level navigation
/// throughout your site.
public struct NavigationBar<Logo: InlineElement, Content: NavigationElement>: HTML {
    /// The color scheme for this navigation bar.
    public enum NavigationBarStyle {
        /// No specific color scheme means this bar will be rendered using
        /// automatic settings.
        case automatic

        /// This bar must always be rendered in light mode.
        case light

        /// This bar must always be rendered in dark mode.
        case dark
    }

    /// How navigation bar items should be aligned horizontally.
    public enum ItemAlignment: String {
        /// Items are aligned to the leading edge
        case leading = ""

        /// Items are aligned in the center
        case center = "justify-content-center"

        /// Items are aligned to the trailing edge
        case trailing = "justify-content-end"

        /// Items are aligned to the trailing edge by default.
        public static var automatic: Self { .trailing }
    }

    /// How the navigation menu toggle button should be styled.
    public enum NavigationMenuStyle: Sendable {
        /// A toggle button with no border.
        case plain

        /// A toggle button with the default border styling.
        case bordered

        /// The default style for navigation menus.
        public static var automatic: Self { .bordered }

        var styles: [InlineStyle] {
            switch self {
            case .plain: [.init(.border, value: "none")]
            case .bordered: []
            }
        }
    }

    /// Which icon should be used in the navigation menu toggle button.
    public enum NavigationMenuIcon: String, Sendable {
        /// A hamburger menu icon (three horizontal lines).
        case bars = "navbar-toggler-icon"

        /// A three-dots menu icon.
        case ellipsis = "bi bi-three-dots"

        /// The default icon for navigation menus.
        public static var automatic: Self { .bars}
    }

    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Controls the maximum width of the navigation bar content at different breakpoints.
    /// By default, uses Bootstrap's container class.
    private var widthClasses: [String] = ["container"]

    /// The icon displayed in the navigation menu toggle button.
    private var toggleIcon: NavigationMenuIcon = .automatic

    /// The visual style applied to the navigation menu toggle button.
    private var toggleMenuStyle: NavigationMenuStyle = .automatic

    /// The main logo for your site, such as an image or some text. This becomes
    /// clickable to let users navigate to your homepage.
    private let logo: Logo

    /// An array of items to show in this navigation bar.
    private let items: NavigationSubviewsCollection

    /// The style to use when rendering this bar.
    private var style = NavigationBarStyle.automatic

    /// How items in this navigation bar should be aligned
    private var itemAlignment = ItemAlignment.automatic

    /// Creates a new `NavigationBar` instance from the `logo`, without any items.
    /// - Parameter logo: The logo to use in the top-left edge of your bar.
    public init(logo: Logo) where Content == EmptyHTML {
        self.logo = logo
        self.items = NavigationSubviewsCollection()
    }

    /// Creates a new `NavigationBar` instance from the `logo`, without any items.
    public init() where Content == EmptyHTML, Logo == EmptyInlineElement {
        self.logo = EmptyInlineElement()
        self.items = NavigationSubviewsCollection()
    }

    /// Creates a new `NavigationBar` instance from the `logo` and `items` provided.
    /// - Parameter items: Basic navigation items like `Link` and `Span` that will be
    ///   collapsed into a hamburger menu at small screen sizes.
    public init(@NavigationElementBuilder items: () -> Content) where Logo == EmptyInlineElement {
        self.logo = EmptyInlineElement()
        self.items = NavigationSubviewsCollection(items())
    }

    /// Creates a new `NavigationBar` instance from the `logo` and `items` provided.
    /// - Parameters:
    ///   - logo: The logo to use in the top-left edge of your bar.
    ///   - items: Basic navigation items like `Link` and `Span` that will be
    ///   collapsed into a hamburger menu at small screen sizes.
    public init(logo: Logo, @NavigationElementBuilder items: () -> Content) {
        self.logo = logo
        self.items = NavigationSubviewsCollection(items())
    }

    /// Creates a new `NavigationBar` instance from the `logo` and `items` provided.
    /// - Parameters:
    ///   - items: Basic navigation items like `Link` and `Span` that will be
    ///   collapsed into a hamburger menu at small screen sizes.
    ///   - logo: The logo to use in the top-left edge of your bar.
    public init(
        @NavigationElementBuilder items: () -> Content,
        @InlineElementBuilder logo: () -> Logo = { EmptyInlineElement() }
    ) {
        self.items = NavigationSubviewsCollection(items())
        self.logo = logo()
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
    public func width(_ width: NavigationBarWidth) -> Self {
        var copy = self
        switch width {
        case .viewport:
            let columnWidth = ColumnWidth.variable.className
            copy.widthClasses = ["container-fluid", columnWidth]
        case .count(let count):
            let columnWidth = ColumnWidth.count(count).className
            copy.widthClasses = ["container", columnWidth]
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

    /// Sets the icon to display in the navigation menu toggle button.
    /// - Parameter icon: The icon to use for the toggle button.
    /// - Returns: A new `NavigationBar` instance with the updated toggle icon.
    public func navigationMenuIcon(_ icon: NavigationMenuIcon) -> Self {
        var copy = self
        copy.toggleIcon = icon
        return copy
    }

    ///  Sets the visual style of the navigation menu toggle button.
    /// - Parameter style: The style to apply to the toggle button.
    /// - Returns: A new `NavigationBar` instance with the updated toggle button style.
    public func navigationMenuStyle(_ style: NavigationMenuStyle) -> Self {
        var copy = self
        copy.toggleMenuStyle = style
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        let pinnedItems = items.filter { $0.navigationBarVisibility == .always }
        let collapsibleItems = items.filter { $0.navigationBarVisibility == .automatic }
        /// The number of controls that aren't `Spacer`,
        /// used to determine the gap class that should be used.
        let visibleControlCount = pinnedItems.count(where: { $0.isSpacer })

        return Tag("header") {
            Tag("nav") {
                Section {
                    if logo.isEmptyInlineElement == false {
                        Section(renderLogo(logo))
                            .class("me-2 me-md-auto")
                    }

                    if pinnedItems.isEmpty == false {
                        Section {
                            renderPinnedItems(pinnedItems)
                            if collapsibleItems.isEmpty == false {
                                // Keep the toggle button on the same line
                                // as the pinned items for a cleaner UI
                                renderToggleButton()
                            }
                        }
                        .class("flex-fill", "flex-md-grow-0", "flex-md-shrink-0")
                        .class("d-flex", "gap-2", "align-items-center", "justify-content-end")
                        .class(visibleControlCount > 1 ? nil : "gap-md-0")
                        .class("ms-auto")
                        .class("order-md-last")
                    }

                    if collapsibleItems.isEmpty == false {
                        if pinnedItems.isEmpty {
                            renderToggleButton()
                        }
                        renderCollapsibleItems(collapsibleItems)
                    }
                }
                .class(widthClasses)
                .class("flex-wrap flex-lg-nowrap")
            }
            .attributes(attributes)
            .class("navbar", "navbar-expand-md")
            .data("bs-theme", theme(for: style))
        }
        .render()
    }

    private func renderPinnedItems(_ items: [NavigationSubview]) -> some HTML {
        ForEach(items) { $0 }
    }

    private func renderToggleButton() -> some InlineElement {
        Button {
            Span()
                .class(toggleIcon.rawValue)
        }
        .style(toggleMenuStyle.styles)
        .class("navbar-toggler")
        .data("bs-toggle", "collapse")
        .data("bs-target", "#navbarCollapse")
        .aria(.controls, "navbarCollapse")
        .aria(.expanded, "false")
        .aria(.label, "Toggle navigation")
    }

    private func renderCollapsibleItems(_ items: [NavigationSubview]) -> some HTML {
        Section {
            List(items) { $0 }
                .class("navbar-nav", "mb-2", "mb-md-0", "col", itemAlignment.rawValue)
        }
        .class("collapse", "navbar-collapse")
        .id("navbarCollapse")
    }

    private func renderLogo(_ logo: some InlineElement) -> some InlineElement {
        Link(logo, target: "/")
            .class("d-inline-flex", "align-items-center")
            .class("navbar-brand")
    }

    private func theme(for style: NavigationBarStyle) -> String? {
        switch style {
        case .automatic: nil
        case .light: "light"
        case .dark: "dark"
        }
    }
}

private extension HTML {
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
