//
// Position.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Specific values that can be used to position this element.
public enum Position: String {
    /// No specific position.
    case `default` = ""

    /// This element stays fixed to the top of the screen.
    case fixedTop = "fixed-top"

    /// This element stays fixed to the bottom of the screen.
    case fixedBottom = "fixed-bottom"

    /// This element is rendered in its natural location until it reaches
    /// the top of the screen, at which point it stays fixed.
    case stickyTop = "sticky-top"

    /// This element is rendered in its natural location until it reaches
    /// the bottom of the screen, at which point it stays fixed.
    case stickyBottom = "sticky-bottom"
}

/// A modifier that applies CSS positioning to HTML elements.
struct PositionModifier: HTMLModifier {
    /// The type of positioning to apply (static, relative, absolute, etc.)
    var position: Position
    
    /// Applies position styling to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with position applied
    func body(content: some HTML) -> any HTML {
        content.class(position.rawValue)
    }
}

public extension BlockHTML {
    /// Adjusts the rendering position for this element, using a handful of
    /// specific, known position values.
    /// - Parameter newPosition: A `Position` case to use for this element.
    /// - Returns: A copy of this element with the new position applied.
    func position(_ newPosition: Position) -> some BlockHTML {
        modifier(PositionModifier(position: newPosition))
    }
}
