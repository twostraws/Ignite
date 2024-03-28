//
// Action.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// One action that can be triggered on the page. Actions compile
/// to JavaScript.
public protocol Action {
    /// Convert this action into the equivalent JavaScript code.
    func compile() -> String
}
