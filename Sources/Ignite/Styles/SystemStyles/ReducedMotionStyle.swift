//
// ReducedMotionStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A style that applies CSS properties when reduced motion is enabled.
public struct ReducedMotionStyle: Style {
    /// The CSS property to modify
    let property: String

    /// The value to apply to the CSS property
    let value: String

    /// The CSS class name to apply when dark mode is enabled (if using class-based styling)
    let targetClass: String?

    /// Creates a new reduced motion color style.
    /// - Parameter value: The color value to apply
    public init(_ value: String) {
        self.value = value
        self.property = "color"
        self.targetClass = nil
    }

    /// Creates a new reduced motion style with custom property and value.
    /// - Parameters:
    ///   - property: The CSS property to modify
    ///   - value: The value to apply
    public init(_ property: Property, value: String) {
        self.property = property.rawValue
        self.value = value
        self.targetClass = nil
    }

    /// Creates a new reduced motion style that applies an existing class.
    public init(class: String) {
        self.property = ""
        self.value = ""
        self.targetClass = `class`
    }

    /// Resolves the style into a concrete implementation
    public var body: some Style {
        ResolvedStyle(
            value: value,
            targetClass: targetClass,
            mediaQueries: [MediaQuery(conditions: ["(prefers-reduced-motion: reduce)"])],
            className: className
        )
    }
}
