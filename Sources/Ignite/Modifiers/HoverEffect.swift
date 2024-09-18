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
    ///   The argument acts as a placeholder representing this page element.
    /// - Returns: The page element with the provided hover effect applied.
    @discardableResult
    func hoverEffect(_ effect: @escaping (EmptyHoverEffect) -> some HoverEffect) -> Self {
        onHover { isHovering in
            if isHovering {
                ApplyHoverEffects(styles: effect(EmptyHoverEffect()).attributes.styles)
            } else {
                RemoveHoverEffects()
            }
        }
    }
}

/// A protocol representing the hover effect css styles to be applied
public protocol HoverEffect {
    var attributes: CoreAttributes { get set }
}

/// An empty hover effect type to which styles can be added
public struct EmptyHoverEffect: HoverEffect {
    public var attributes = CoreAttributes()
}

private struct ApplyHoverEffects: Action {
    let styles: [AttributeValue]

    func compile() -> String {
        """
        this.unhoveredStyle = this.style.cssText;
        \(styles.map { "this.style.\($0.name.convertingCSSNamesToJS()) = '\($0.value)'" }.joined(separator: "; "))
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
