//
// NavigationElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that allows elements to be configured for placement in a navigation bar.
@MainActor
protocol NavigationElementRenderable {
    /// The navigation representation of this element.
    func renderAsNavigationElement() -> Markup
}

/// Describes elements that can be placed into navigation bars.
/// - Warning: Do not conform to this type directly.
@MainActor
public protocol NavigationElement {
    /// Core attributes for the navigation element.
    var attributes: CoreAttributes { get set }

    /// Renders the element as markup.
    /// - Returns: The rendered markup for the element.
    func render() -> Markup

    /// How a `NavigationBar` displays this item at different breakpoints.
    var navigationBarVisibility: NavigationBarVisibility { get set }

    /// Returns a new instance with the specified visibility.
    func navigationBarVisibility(_ visibility: NavigationBarVisibility) -> Self
}

public extension NavigationElement {
    /// Returns a new instance with the specified visibility.
    /// - Parameter visibility: The visibility to apply.
    /// - Returns: A new instance with the updated visibility.
    func navigationBarVisibility(_ visibility: NavigationBarVisibility) -> Self {
        var copy = self
        copy.navigationBarVisibility = visibility
        return copy
    }
}

public extension NavigationElement where Self: HTML {
    /// Generates the complete `HTML` string representation of the element.
    func render() -> Markup {
        if isPrimitive {
            body.render()
        } else {
            fatalError("This protocol should not be conformed to directly.")
        }
    }
}

public extension NavigationElement where Self: InlineElement {
    /// Generates the complete `HTML` string representation of the element.
    func render() -> Markup {
        if isPrimitive {
            body.render()
        } else {
            fatalError("This protocol should not be conformed to directly.")
        }
    }
}

extension NavigationElement where Self: InlineElement {
    /// Adds a CSS class to the HTML element
    /// - Parameter className: The CSS class name to add
    /// - Returns: A modified copy of the element with the CSS class added
    func `class`(_ className: String) -> Self {
        guard !className.isEmpty else { return self }
        var copy = self
        copy.attributes.append(classes: className)
        return copy
    }
}

extension NavigationElement where Self: HTML {
    /// Adds a CSS class to the HTML element
    /// - Parameter className: The CSS class name to add
    /// - Returns: A modified copy of the element with the CSS class added
    func `class`(_ className: String) -> Self {
        guard !className.isEmpty else { return self }
        var copy = self
        copy.attributes.append(classes: className)
        return copy
    }
}

extension NavigationElement where Self: BodyElement {
    /// Adds a CSS class to the HTML element
    /// - Parameter className: The CSS class name to add
    /// - Returns: A modified copy of the element with the CSS class added
    func `class`(_ className: String) -> Self {
        guard !className.isEmpty else { return self }
        var copy = self
        copy.attributes.append(classes: className)
        return copy
    }

    /// Adds inline styles to the element.
    /// - Parameter styles: An array of `InlineStyle` objects
    /// - Returns: The modified `HTML` element
    func style(_ styles: [InlineStyle]) -> Self {
        guard styles.isEmpty == false else { return self }
        var copy = self
        copy.attributes.append(styles: styles)
        return copy
    }
}
