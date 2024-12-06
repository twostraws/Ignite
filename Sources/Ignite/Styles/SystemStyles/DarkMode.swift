//
// DarkMode.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A style that applies CSS properties when dark mode is enabled.
///
/// DarkMode allows you to define styles that only take effect when the system
/// or browser is using a dark color scheme.
public struct DarkMode: Style {
    /// The CSS property to modify (e.g., "color", "font-size")
    let property: String

    /// The value to apply to the CSS property
    let value: String

    /// The CSS class name to apply when dark mode is enabled (if using class-based styling)
    let targetClass: String?

    /// Creates a new dark mode color style.
    /// - Parameter value: The color value to apply
    public init(_ value: String) {
        self.value = value
        self.property = "color"
        self.targetClass = nil
    }

    /// Creates a new dark mode style with custom property and value.
    /// - Parameters:
    ///   - property: The CSS property to modify
    ///   - value: The value to apply
    public init(_ property: Property, value: String) {
        self.property = property.rawValue
        self.value = value
        self.targetClass = nil
    }

    /// Resolves the style into a concrete implementation
    public var body: some Style {
        ResolvedStyle(
            value: value,
            mediaQueries: [MediaQuery(conditions: ["(prefers-color-scheme: dark)"])],
            className: className
        )
    }
}

public extension Style {
    /// Applies styles when dark mode is enabled.
    /// - Returns: A style that only applies in dark mode
    func darkMode() -> some Style {
        chain(with: "(prefers-color-scheme: dark)")
    }
}
