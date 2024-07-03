//
// ShowBoxShadow.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Hides a previously applied box shadow of the element it is applied to, e.g. onHover(false).
public struct HideBoxShadow: Action {

    /// Creates a new HideBoxShadow action.
    public init() { }

    /// Renders this action using publishing context passed in.
    /// - Returns: The JavaScript for this action.
    public func compile() -> String {
        "this.style.boxShadow=''"
    }
}
