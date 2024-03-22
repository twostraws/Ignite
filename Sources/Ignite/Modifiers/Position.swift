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

extension BlockElement {

    /// Adjusts the rendering position for this element, using a handful of
    /// specific, known position values.
    /// - Parameter newPosition: A `Position` case to use for this element.
    /// - Returns: A copy of this element with the new position applied.
    public func position(_ newPosition: Position) -> Self {
        self.class(newPosition.rawValue)
    }
}
