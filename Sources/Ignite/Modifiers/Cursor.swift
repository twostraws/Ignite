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

/// A modifier that changes the cursor appearance when hovering over elements
struct CursorModifier: HTMLModifier {
    /// The cursor style to apply
    private let cursor: Cursor

    /// Creates a new cursor modifier
    /// - Parameter cursor: The desired cursor style
    init(_ cursor: Cursor) {
        self.cursor = cursor
    }

    /// Applies the cursor style to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with cursor styling applied
    func body(content: some HTML) -> any HTML {
        content.style("cursor: \(cursor.rawValue)")
    }
}

public extension HTML {
    /// Changes the cursor appearance of the element when hovering over the element.
    /// - Parameter cursor: The desired cursor style.
    /// - Returns: A modified copy of the element with cursor styling applied
    func cursor(_ cursor: Cursor) -> some HTML {
        modifier(CursorModifier(cursor))
    }
}
