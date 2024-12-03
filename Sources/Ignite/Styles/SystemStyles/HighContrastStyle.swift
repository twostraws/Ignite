//
// HighContrastStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A style that applies CSS properties when high contrast mode is enabled.
public struct HighContrastStyle: Style {
    /// The CSS property to modify
    let property: String

    /// The value to apply to the CSS property
    let value: String

    /// The CSS class name to apply when dark mode is enabled (if using class-based styling)
    let targetClass: String?

    /// Creates a new high contrast color style.
    /// - Parameter value: The color value to apply
    public init(_ value: String) {
        self.value = value
        self.property = "color"
        self.targetClass = nil
    }

    /// Creates a new high contrast style with custom property and value.
    /// - Parameters:
    ///   - property: The CSS property to modify
    ///   - value: The value to apply
    public init(_ property: Property, value: String) {
        self.property = property.rawValue
        self.value = value
        self.targetClass = nil
    }

    /// Creates a new high contrast style that applies an existing class.
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
            mediaQueries: [MediaQuery(conditions: ["(prefers-contrast: more)"])],
            className: className
        )
    }
}

public extension Style {
    /// Applies styles when high contrast mode is enabled
    /// - Returns: A style that only applies in high contrast mode
    func highContrast() -> some Style {
        chain(with: "(prefers-contrast: more)")
    }
}
