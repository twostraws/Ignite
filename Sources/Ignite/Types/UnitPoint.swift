//
// UnitPoint.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

// An x/y coordinate in the ranges 0 through 1.
public struct UnitPoint: Hashable, Sendable {
    var x: Double // swiftlint:disable:this identifier_name
    var y: Double // swiftlint:disable:this identifier_name

    /// Calculates the angle from this `UnitPoint` to another,
    /// measured in radians.
    /// - Parameter endPoint: The `UnitPoint` we're angling towards.
    /// - Returns: The angle between the two points, measured in radians.
    public func radians(to endPoint: UnitPoint) -> Double {
        // Differences in x and y coordinates
        let deltaX = endPoint.x - self.x
        let deltaY = endPoint.y - self.y

        // Calculate the angle, making sure it's positive.
        let angle = atan2(deltaY, deltaX) + .pi / 2
        return (angle < 0) ? (angle + 2 * .pi) : angle
    }

    /// Calculates the angle from this `UnitPoint` to another,
    /// measured in degrees.
    /// - Parameter endPoint: The `UnitPoint` we're angling towards.
    /// - Returns: The angle between the two points, measured in degrees.
    public func degrees(to endPoint: UnitPoint) -> Double {
        radians(to: endPoint) * 180 / .pi
    }

    public static let topLeading = UnitPoint(x: 0, y: 0)
    public static let top = UnitPoint(x: 0.5, y: 0)
    public static let topTrailing = UnitPoint(x: 1, y: 0)
    public static let leading = UnitPoint(x: 0, y: 0.5)
    public static let center = UnitPoint(x: 0.5, y: 0.5)
    public static let trailing = UnitPoint(x: 1, y: 0.5)
    public static let bottomLeading = UnitPoint(x: 0, y: 1)
    public static let bottom = UnitPoint(x: 0.5, y: 1)
    public static let bottomTrailing = UnitPoint(x: 1, y: 1)
}
