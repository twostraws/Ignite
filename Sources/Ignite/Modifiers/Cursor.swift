//
// Cursor.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public enum Cursor: String {
    /// The cursor to display based on the current context. E.g., equivalent to text when hovering text.
    case auto

    /// Default cursor. Typically an arrow.
    case `default`

    /// No cursor is rendered.
    case pointer

    /// Something can be zoomed (magnified) in.
    case zoomIn = "zoom-in"

    /// Something can be zoomed (magnified) out.
    case zoomOut = "zoom-out"
}

public extension PageElement {
    /// Changes the cursor appearance of the element when hovering over the element.
    /// - Parameter cursor: The desired cursor style.
    /// - Returns: The current element with the updated cursor style applied.
    func cursor(_ cursor: Cursor) -> Self {
        self.style("cursor: \(cursor.rawValue)")
    }
}
