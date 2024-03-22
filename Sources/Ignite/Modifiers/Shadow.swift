//
// Shadow.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

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
        self.style("box-shadow: \(color) \(x)px \(y)px \(radius)px inset")
    }

    /// Applies a drop shadow to this element.
    /// - Parameters:
    ///   - color: The shadow's color. Defaults to black at 33% opacity.
    ///   - radius: The shadow's radius
    ///   - x: The X offset for the shadow, specified in pixels. Defaults to 0.
    ///   - y: The Y offset for the shadow, specified in pixels. Defaults to 0.
    /// - Returns: A copy of this element with the updated shadow applied.
    public func shadow(_ color: Color = .black.opacity(0.33), radius: Int, x: Int = 0, y: Int = 0) -> Self {
        self.style("box-shadow: \(color) \(x)px \(y)px \(radius)px")
    }
}
// swiftlint:enable identifier_name
