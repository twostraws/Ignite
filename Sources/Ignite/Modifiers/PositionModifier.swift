//
// Position.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Adjusts the rendering position for this element, using a handful of
    /// specific, known position values.
    /// - Parameter newPopositionsition: A `Position` case to use for this element.
    /// - Returns: A copy of this element with the new position applied.
    func position(_ position: Position) -> some HTML {
        self.class(position.rawValue)
    }
}
