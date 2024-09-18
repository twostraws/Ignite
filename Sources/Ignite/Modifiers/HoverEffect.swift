//
// HoverEffect.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public extension PageElement {
    /// Applies a hover effect to the page element
    /// - Parameter effect: A closure that returns the effect to be applied.
    ///                     The argument acts as a placeholder representing this page element.
    /// - Returns: The page element with the provided hover effect applied.
    @discardableResult
    func hoverEffect(_ effect: @escaping (EmptyHoverEffect) -> some HoverEffect) -> Self {
        onHover { isHovering in
            if isHovering {
                ApplyHoverEffects(styles: effect(EmptyHoverEffect()).styles)
            } else {
                RemoveHoverEffects()
            }
        }
    }
}

/// A protocol representing the hover effect css styles to be applied
public protocol HoverEffect {
    var styles: [AttributeValue] { get set }
}

/// An empty hover effect type to which styles can be added
public struct EmptyHoverEffect: HoverEffect {
    public var styles: [AttributeValue] = []
}

extension HoverEffect {
    // swiftlint:disable identifier_name
    /// Adds a shadow hover effect
    /// - Parameters:
    ///   - color: The shadow's color. Defaults to black at 33% opacity.
    ///   - radius: The shadow's radius
    ///   - x: The X offset for the shadow, specified in pixels. Defaults to 0.
    ///   - y: The Y offset for the shadow, specified in pixels. Defaults to 0.
    /// - Returns: A copy of the hover effect with the shadow hover effect applied.
    public func shadow(
        color: Color = .black.opacity(0.1),
        radius: Int = 8,
        x: Int = 0,
        y: Int = 0
    ) -> some HoverEffect {
        addingStyle(.init(
            name: "boxShadow",
            value: "\(Shadow(color: color, radius: radius, x: x, y: y))")
        )
    }
    // swiftlint:enable identifier_name

    /// Adds background color hover effect
    /// - Parameter color: The color to be used for the background
    /// - Returns: A copy of the hover effect with the color hover effect applied.
    public func background(_ color: Color) -> some HoverEffect {
        addingStyle(.init(
            name: "backgroundColor",
            value: "\(color)")
        )
    }

    func addingStyle(_ style: AttributeValue) -> some HoverEffect {
        var copy = self
        copy.styles.append(style)
        return copy
    }
}

private struct ApplyHoverEffects: Action {
    let styles: [AttributeValue]

    func compile() -> String {
        """
        this.unhoveredStyle = this.style.cssText;
        \(styles.map { "this.style.\($0.name) = '\($0.value)'" }.joined(separator: "; "))
        """
    }
}

private struct RemoveHoverEffects: Action {
    func compile() -> String {
        """
        this.style.cssText = this.unhoveredStyle;
        """
    }
}
