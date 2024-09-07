//
// Shadow.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A type used to define a box-shadow
struct Shadow: CustomStringConvertible {
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
    var description: String {
        "\(color) \(x)px \(y)px \(radius)px \(inset == true ? "inset" : "")"
    }
}

// X and Y are correct names here.
// swiftlint:disable identifier_name
extension BlockElement {
    /// Applies an inner shadow to this element.
    /// - Parameters:
    ///   - color: The shadow's color. Defaults to black at 33% opacity.
    ///   - radius: The shadow's radius
    ///   - x: The X offset for the shadow, specified in pixels. Defaults to 0.
    ///   - y: The Y offset for the shadow, specified in pixels. Defaults to 0.
    /// - Returns: A copy of this element with the updated shadow applied.
    public func innerShadow(_ color: Color = .black.opacity(0.33), radius: Int, x: Int = 0, y: Int = 0) -> Self {
        let shadow = Shadow(color: color, radius: radius, x: x, y: y, inset: true)
        return style("box-shadow: \(shadow)")
    }

    /// Applies a drop shadow to this element.
    /// - Parameters:
    ///   - color: The shadow's color. Defaults to black at 33% opacity.
    ///   - radius: The shadow's radius
    ///   - x: The X offset for the shadow, specified in pixels. Defaults to 0.
    ///   - y: The Y offset for the shadow, specified in pixels. Defaults to 0.
    /// - Returns: A copy of this element with the updated shadow applied.
    public func shadow(_ color: Color = .black.opacity(0.33), radius: Int, x: Int = 0, y: Int = 0) -> Self {
        let shadow = Shadow(color: color, radius: radius, x: x, y: y, inset: false)
        return style("box-shadow: \(shadow)")
    }
}
// swiftlint:enable identifier_name
