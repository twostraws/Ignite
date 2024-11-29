//
// LowContrastStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A style that applies CSS properties when low contrast mode is enabled.
public struct LowContrastStyle: Style {
    /// The CSS property to modify
    let property: String

    /// The value to apply to the CSS property
    let value: String

    /// The CSS class name to apply when dark mode is enabled (if using class-based styling)
    let targetClass: String?

    /// Creates a new low contrast color style.
    /// - Parameter value: The color value to apply
    public init(_ value: String) {
        self.value = value
        self.property = "color"
        self.targetClass = nil
    }

    /// Creates a new low contrast style with custom property and value.
    /// - Parameters:
    ///   - property: The CSS property to modify
    ///   - value: The value to apply
    public init(_ property: Property, value: String) {
        self.property = property.rawValue
        self.value = value
        self.targetClass = nil
    }

    /// Creates a new low contrast style that applies an existing class.
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
            mediaQueries: [MediaQuery(conditions: ["(prefers-contrast: less)"])],
            className: className
        )
    }
}

public extension Style {
    /// Applies styles when low contrast mode is enabled
    /// - Returns: A style that only applies in low contrast mode
    func lowContrast() -> some Style {
        chain(with: "(prefers-contrast: less)")
    }
}
