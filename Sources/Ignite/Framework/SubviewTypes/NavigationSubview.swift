//
// NavigationSubview.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container that wraps navigation elements and manages their rendering behavior.
struct NavigationSubview: HTML {
    /// The content and behavior of this HTML.
    var body: some HTML { self }

    var attributes = CoreAttributes()

    /// The navigation element to be rendered.
    private var content: any NavigationElement

    /// The underlying HTML content, with attributes.
    var wrapped: any NavigationElement {
        var wrapped = content
        wrapped.attributes.merge(attributes)
        return wrapped
    }

    /// Whether this element resolves to a `Spacer`.
    var isSpacer: Bool {
        content is any SpacerProvider
    }

    /// Controls the visibility of the navigation bar.
    var navigationBarVisibility: NavigationBarVisibility = .automatic

    /// Creates a navigation subview with the specified content.
    /// - Parameter content: The navigation element to wrap.
    init(_ content: any NavigationElement) {
        self.content = content

        if let provider = content as? any NavigationBarVisibilityProvider {
            self.navigationBarVisibility = provider.navigationBarVisibility
        }
    }

    /// Renders the navigation content as markup.
    /// - Returns: The rendered markup for the navigation element.
    func render() -> Markup {
        return if let element = wrapped as? any NavigationElementRenderable {
            element.renderAsNavigationElement()
        } else {
            wrapped.render()
        }
    }
}
