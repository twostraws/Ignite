//
// Cursor.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public enum Cursor: String, CaseIterable, Sendable {
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
