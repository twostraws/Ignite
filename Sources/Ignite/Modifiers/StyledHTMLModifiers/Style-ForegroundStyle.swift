//
// Style-ForegroundStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension StyledHTML {
    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: Color) -> Self {
        self.style(.color, color.description)
    }

    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a `String`.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: String) -> Self {
        self.style(.color, color)
    }
}
