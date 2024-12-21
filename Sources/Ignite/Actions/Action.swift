//
// Action.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// One action that can be triggered on the page. Actions compile
/// to JavaScript.
public protocol Action: Sendable {
    /// Convert this action into the equivalent JavaScript code.
    func compile() -> String
}
