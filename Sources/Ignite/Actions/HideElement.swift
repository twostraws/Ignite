//
// HideElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Hides a page element by appending the "d-none" CSS class.
public struct HideElement: Action {
    /// The unique identifier of the element we're trying to hide.
    var id: String

    /// Creates a new HideElement action from a specific page element ID.
    /// - Parameter id: The unique identifier of the element we're trying to hide.
    public init(_ id: String) {
        self.id = id
    }

    /// Renders this action using publishing context passed in.
    /// - Returns: The JavaScript for this action.
    public func compile() -> String {
        "document.getElementById('\(id)').classList.add('d-none')"
    }
}
