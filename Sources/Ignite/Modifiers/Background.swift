//
// Background.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Custom background styles that involve creating gradients.
public enum BackgroundStyle {
    /// A linear gradient between two fixed locations.
    case linearGradient(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint)

    /// A radial gradient, emanating outwards.
    case radialGradient(colors: [Color])

    /// The CSS style string for this background effect.
    var style: String {
        switch self {
        case let .linearGradient(colors, startPoint, endPoint):
            let angle = Int(startPoint.degrees(to: endPoint))
            let colorsString = colors.map(\.description).joined(separator: ", ")
            return "linear-gradient(\(angle)deg, \(colorsString))"
        case let .radialGradient(colors):
            let colorsString = colors.map(\.description).joined(separator: ", ")
            return "radial-gradient(\(colorsString))"
        }
    }
}

extension HoverEffect {
    /// Applies a background color from a string.
    /// - Parameter color: The specific color value to use, specified as a
    /// hex string such as "#FFE700".
    /// - Returns: The current element with the updated background color.
    @available(*, deprecated, renamed: "background(_:)")
    public func backgroundColor(_ color: String) -> Self {
        self.style("background-color: \(color)")
    }

    /// Applies a background color from a `Color` object.
    /// - Parameter color: The specific color value to use, specified as
    /// a `Color` instance.
    /// - Returns: The current element with the updated background color.
    @available(*, deprecated, renamed: "background(_:)")
    public func backgroundColor(_ color: Color) -> Self {
        self.style("background-color: \(color.description)")
    }

    /// Applies a background color from a string.
    /// - Parameter color: The specific color value to use, specified as a
    /// hex string such as "#FFE700".
    /// - Returns: The current element with the updated background color.
    public func background(_ color: String) -> Self {
        self.style("background-color: \(color)")
    }

    /// Applies a background color from a `Color` object.
    /// - Parameter color: The specific color value to use, specified as
    /// a `Color` instance.
    /// - Returns: The current element with the updated background color.
    public func background(_ color: Color) -> Self {
        self.style("background-color: \(color.description)")
    }

    /// Applies a background color from one or more `BackgroundStyle` cases.
    /// - Parameter style: The specific styles to use, specified as
    /// one or more `BackgroundStyle` instance. Specifying multiple
    /// gradients causes them to overlap, so you should blend them with opacity.
    /// - Returns: The current element with the updated background styles.
    public func background(_ styles: BackgroundStyle...) -> Self {
        guard styles.isEmpty == false else { return self }

        let grouped = styles.map(\.style).joined(separator: ", ")
        return self.style("background: \(grouped)")
    }
}
