//
// BasicStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A basic style that applies a single CSS property with a value.
///
/// BasicStyle is the fundamental building block for creating styles in Ignite.
/// It represents a single CSS property-value pair that can be combined with other
/// styles using the style builder system.
///
/// Example:
/// ```swift
/// let redText = BasicStyle(.color, value: "#ff0000")
/// let largeText = BasicStyle(.fontSize, value: "2rem")
/// ```
public struct BasicStyle: Style {
    /// The CSS property to set (e.g., "color", "font-size")
    let property: String

    /// The value to apply to the CSS property
    let value: String

    /// Creates a new style with the specified color value.
    /// - Parameter value: The color value to apply
    public init(_ value: String) {
        self.value = value
        self.property = Property.color.rawValue
    }

    /// Creates a new style with the specified property and value.
    /// - Parameters:
    ///   - property: The CSS property to set
    ///   - value: The value to apply to the property
    public init(_ property: Property, value: any LengthUnit) {
        self.property = property.rawValue
        self.value = value.description
    }

    /// Creates a new style that applies an existing class.
    public init(class: String) {
        self.property = ""
        self.value = ""
    }

    /// Resolves this style into its concrete form.
    public var body: some Style {
        ResolvedStyle(
            declarations: [.init(name: property, value: value)],
            className: className
        )
    }
}
