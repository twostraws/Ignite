//
// Shadow.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

// X and Y are correct names here.
// swiftlint:disable identifier_name
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

/// A modifier that applies box shadow styling to HTML elements.
struct ShadowModifier: HTMLModifier {
    /// The shadow's color
    var color: Color
    
    /// The shadow's blur radius in pixels
    var radius: Int
    
    /// The horizontal offset in pixels
    var x: Int
    
    /// The vertical offset in pixels
    var y: Int
    
    /// Whether the shadow should be inset
    var inset: Bool
    
    /// Computed shadow configuration
    private var shadow: Shadow {
        Shadow(color: color, radius: radius, x: x, y: y, inset: inset)
    }
    
    /// Applies box shadow styling to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with box shadow applied
    func body(content: some HTML) -> any HTML {
        content.style("box-shadow: \(shadow)")
    }
}

public extension HTML {
    /// Applies an inner shadow to this element.
    /// - Parameters:
    ///   - color: The shadow's color. Defaults to black at 33% opacity.
    ///   - radius: The shadow's radius
    ///   - x: The X offset for the shadow, specified in pixels. Defaults to 0.
    ///   - y: The Y offset for the shadow, specified in pixels. Defaults to 0.
    /// - Returns: A copy of this element with the updated shadow applied.
    func innerShadow(_ color: Color = .black.opacity(0.33), radius: Int, x: Int = 0, y: Int = 0) -> some HTML {
        modifier(ShadowModifier(color: color, radius: radius, x: x, y: y, inset: true))
    }

    /// Applies a drop shadow to this element.
    /// - Parameters:
    ///   - color: The shadow's color. Defaults to black at 33% opacity.
    ///   - radius: The shadow's radius
    ///   - x: The X offset for the shadow, specified in pixels. Defaults to 0.
    ///   - y: The Y offset for the shadow, specified in pixels. Defaults to 0.
    /// - Returns: A copy of this element with the updated shadow applied.
    func shadow(_ color: Color = .black.opacity(0.33), radius: Int, x: Int = 0, y: Int = 0) -> some HTML {
        modifier(ShadowModifier(color: color, radius: radius, x: x, y: y, inset: false))
    }
}
// swiftlint:enable identifier_name
