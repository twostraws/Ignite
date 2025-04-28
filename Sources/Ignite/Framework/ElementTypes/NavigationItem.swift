//
// NavigationItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Describes elements that can be placed into navigation bars.
/// - Warning: Do not conform to this type directly.
public protocol NavigationItem: BodyElement {}

@MainActor
protocol NavigationItemConfigurable: BodyElement {
    var isNavigationItem: Bool { get set }
    func configuredAsNavigationItem(_ isNavItem: Bool) -> Self
}

extension NavigationItemConfigurable {
    /// Configures this element to be placed inside a `NavigationBar`.
    /// - Returns: A new element instance suitable for placement
    /// inside a `NavigationBar`.
    func configuredAsNavigationItem(_ isNavItem: Bool = true) -> Self {
        var copy = self
        copy.isNavigationItem = isNavItem
        return copy
    }
}

public extension NavigationItem where Self: HTML {
    /// Generates the complete `HTML` string representation of the element.
    func markup() -> Markup {
        if isPrimitive {
            body.markup()
        } else {
            fatalError("This protocol should not be conformed to directly.")
        }
    }
}

public extension NavigationItem where Self: InlineElement {
    /// Generates the complete `HTML` string representation of the element.
    func markup() -> Markup {
        if isPrimitive {
            body.markup()
        } else {
            fatalError("This protocol should not be conformed to directly.")
        }
    }
}

extension NavigationItem where Self: InlineElement {
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

extension NavigationItem where Self: HTML {
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

extension NavigationItem where Self: BodyElement {
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
