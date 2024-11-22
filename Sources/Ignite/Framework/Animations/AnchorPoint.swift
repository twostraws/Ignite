//
// AnchorPoint.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Specifies the origin point for transform operations like rotation.
/// This value maps directly to CSS's transform-origin property.
public enum AnchorPoint: Sendable {
    /// Centers the transform origin in both axes (50% 50%)
    case center

    /// Places the transform origin at the top-left corner (0% 0%)
    case topLeft

    /// Places the transform origin at the top-right corner (100% 0%)
    case topRight

    /// Places the transform origin at the bottom-left corner (0% 100%)
    case bottomLeft

    /// Places the transform origin at the bottom-right corner (100% 100%)
    case bottomRight

    /// Places the transform origin at the center of the top edge (50% 0%)
    case top

    /// Places the transform origin at the center of the bottom edge (50% 100%)
    case bottom

    /// Places the transform origin at the center of the left edge (0% 50%)
    case left

    /// Places the transform origin at the center of the right edge (100% 50%)
    case right

    /// Allows for custom positioning of the transform origin using CSS units
    /// - Parameters:
    ///   - x: Horizontal position (e.g., "50%", "100px")
    ///   - y: Vertical position (e.g., "50%", "100px")
    case custom(x: String, y: String)

    /// The CSS value for the transform-origin property
    var value: String {
        switch self {
        case .center: "center"
        case .topLeft: "top left"
        case .topRight: "top right"
        case .bottomLeft: "bottom left"
        case .bottomRight: "bottom right"
        case .top: "top"
        case .bottom: "bottom"
        case .left: "left"
        case .right: "right"
        case .custom(let x, let y): "\(x) \(y)"
        }
    }
}
