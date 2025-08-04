//
// NavigationItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container that wraps navigation elements with visibility control.
///
/// Use `NavigationItem` to control how content appears in navigation bars
/// across different screen sizes and breakpoints.
struct NavigationItem<Content: NavigationElement>: NavigationElement {
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// How a `NavigationBar` displays this item at different breakpoints.
    var navigationBarVisibility: NavigationBarVisibility = .automatic

    /// The wrapped navigation content.
    private var content: Content

    /// Creates a navigation item with builder syntax.
    /// - Parameters:
    ///   - visibility: Controls display behavior across breakpoints.
    ///   - content: A closure that builds the navigation content.
    init(
        visibility: NavigationBarVisibility = .automatic,
        @NavigationElementBuilder content: () -> Content
    ) {
        self.navigationBarVisibility = visibility
        self.content = content()
    }

    /// Creates a navigation item with direct content.
    /// - Parameters:
    ///   - visibility: Controls display behavior across breakpoints.
    ///   - content: The navigation content to wrap.
    init(
        visibility: NavigationBarVisibility = .automatic,
        content: Content
    ) {
        self.navigationBarVisibility = visibility
        self.content = content
    }

    /// Renders the navigation item as HTML markup.
    /// - Returns: The rendered markup for the wrapped content.
    func render() -> Markup {
        content.render()
    }
}

extension NavigationItem: NavigationBarVisibilityProvider {}
