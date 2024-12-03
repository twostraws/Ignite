//
// OrientationStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A style that applies CSS properties based on the device's screen orientation.
public struct OrientationStyle: Style {
    /// The CSS property to modify (e.g., "color", "font-size")
    let property: String

    /// The value to apply to the CSS property
    let value: String

    /// The CSS class name to apply when dark mode is enabled (if using class-based styling)
    let targetClass: String?

    /// The target screen orientation
    let orientation: Orientation

    /// Creates a new orientation-specific color style.
    /// - Parameters:
    ///   - value: The color value to apply
    ///   - orientation: The target screen orientation
    public init(_ value: String, orientation: Orientation) {
        self.value = value
        self.property = "color"
        self.orientation = orientation
        self.targetClass = nil
    }

    /// Creates a new orientation-specific style with custom property and value.
    /// - Parameters:
    ///   - property: The CSS property to modify
    ///   - value: The value to apply
    ///   - orientation: The target screen orientation
    public init(property: Property, value: String, orientation: Orientation) {
        self.property = property.rawValue
        self.value = value
        self.orientation = orientation
        self.targetClass = nil
    }

    /// Creates a new orientation-specific style with an existing class.
    public init(class: String, orientation: Orientation) {
        self.property = ""
        self.value = ""
        self.targetClass = `class`
        self.orientation = orientation
    }

    /// Resolves the style into a concrete implementation
    public var body: some Style {
        ResolvedStyle(
            value: value,
            targetClass: targetClass,
            mediaQueries: [MediaQuery(conditions: ["(orientation: \(orientation.rawValue))"])],
            className: className
        )
    }
}

public extension Style {
    /// Applies styles when the device matches the specified orientation.
    /// - Parameter orientation: The target screen orientation
    /// - Returns: A style that only applies in the specified orientation
    func orientation(_ orientation: Orientation) -> some Style {
        chain(with: "(orientation: \(orientation.rawValue))")
    }
}
