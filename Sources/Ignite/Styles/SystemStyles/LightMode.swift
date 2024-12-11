//
// LightMode.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A style that applies CSS properties when light mode is enabled.
///
/// LightMode allows you to define styles that only take effect when the system
/// or browser is using a light color scheme.
public struct LightMode: Style {
    /// The CSS property to modify (e.g., "color", "font-size")
    let property: String

    /// The value to apply to the CSS property
    let value: String

    /// Creates a new light mode color style.
    /// - Parameter value: The color value to apply
    public init(_ value: String) {
        self.value = value
        self.property = "color"
    }

    /// Creates a new light mode style with custom property and value.
    /// - Parameters:
    ///   - property: The CSS property to modify
    ///   - value: The value to apply
    public init(_ property: Property, value: String) {
        self.property = property.rawValue
        self.value = value
    }

    /// Creates a new light mode style that applies an existing class.
    public init(class: String) {
        self.property = ""
        self.value = ""
    }

    /// Resolves the style into a concrete implementation
    public var body: some Style {
        ResolvedStyle(
            declarations: [.init(name: property, value: value)],
            mediaQueries: [MediaQuery(conditions: ["(prefers-color-scheme: light)"])],
            className: className
        )
    }
}

public extension Style {
    /// Applies styles when light mode is enabled.
    /// - Returns: A style that only applies in light mode
    func lightMode() -> some Style {
        chain(with: "(prefers-color-scheme: light)")
    }
}
