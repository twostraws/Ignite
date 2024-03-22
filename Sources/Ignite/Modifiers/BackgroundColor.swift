//
// BackgroundColor.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension BlockElement {
    /// Applies a background color from a string.
    /// - Parameter color: The specific color value to use, specified as a
    /// hex string such as "#FFE700".
    /// - Returns: The current element with the updated background color.
    public func backgroundColor(_ color: String) -> Self {
        self.style("background-color: \(color)")
    }

    /// Applies a background color from a `Color` object.
    /// - Parameter color: The specific color value to use, specified as
    /// a `Color` instance.
    /// - Returns: The current element with the updated background color.
    public func backgroundColor(_ color: Color) -> Self {
        self.style("background-color: \(color.description)")
    }
}
