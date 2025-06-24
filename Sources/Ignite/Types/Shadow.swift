//
// Shadow.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

// swiftlint:disable identifier_name
/// A type used to define a box-shadow
public struct Shadow: CustomStringConvertible, Sendable {
    /// The shadow's color.
    let color: Color

    /// The shadow's radius
    let radius: Int

    /// The X offset for the shadow, specified in pixels. Defaults to 0.
    var x: Int = 0

    /// The Y offset for the shadow, specified in pixels. Defaults to 0.
    var y: Int = 0

    /// Wether the shadow is inset or not
    var inset = false

    /// The CSS representation of this shadow.
    public var description: String {
        "\(color) \(x)px \(y)px \(radius)px \(inset == true ? "inset" : "")"
    }

    /// Creates a new shadow configuration.
    /// - Parameters:
    ///   - color: The color of the shadow. Defaults to black with 33% opacity.
    ///   - radius: The blur radius of the shadow in pixels.
    ///   - x: The horizontal offset of the shadow in pixels. Defaults to 0.
    ///   - y: The vertical offset of the shadow in pixels. Defaults to 0.
    /// - Returns: A new shadow configuration.
    public init(color: Color, radius: Int, x: Int, y: Int) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }

    init(color: Color, radius: Int, x: Int, y: Int, inset: Bool = false) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
        self.inset = inset
    }
}
// swiftlint:enable identifier_name
