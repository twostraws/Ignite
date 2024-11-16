//
// ShowElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Shows a page element by removing the "d-none" CSS class.
public struct ShowElement: Action {
    /// The unique identifier of the element we're trying to hide.
    var id: String

    /// Creates a new ShowElement action from a specific page element ID.
    /// - Parameter id: The unique identifier of the element we're trying to hide.
    public init(_ id: String) {
        self.id = id
    }

    /// Renders this action using publishing context passed in.
    /// - Returns: The JavaScript for this action.
    public func compile() -> String {
        "document.getElementById('\(id)').classList.remove('d-none')"
    }
}
