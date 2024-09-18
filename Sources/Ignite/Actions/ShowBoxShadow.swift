//
// ShowBoxShadow.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
// swiftlint:disable identifier_name
/// Shows a box shadow around the element it is applied e.g. onHover(true)
public struct ShowBoxShadow: Action {
    var color: Color = .black.opacity(0.1)
    var radius: Int = 8

    var x: Int = 0
    var y: Int = 0

    /// Creates a ShowBoxShadow action with the provided shadow parameters
    /// - Parameters:
    ///   - color: The shadow's color.
    ///   - radius: The shadow's radius
    ///   - x: The X offset for the shadow, specified in pixels. Defaults to 0.
    ///   - y: The Y offset for the shadow, specified in pixels. Defaults to 0.
    public init(color: Color = .black.opacity(0.1), radius: Int = 8, x: Int = 0, y: Int = 0) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }

    var shadow: Shadow {
        Shadow(color: color, radius: radius, x: x, y: y)
    }

    public func compile() -> String {
        "this.style.boxShadow='\(shadow.description)'"
    }
}
// swiftlint:enable identifier_name
