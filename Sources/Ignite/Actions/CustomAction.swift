//
// CustomAction.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Allows the user to inject hand-written JavaScript into an event. The code you provide
/// will automatically be escaped.
public struct CustomAction: Action {
    /// The JavaScript code to execute.
    var code: String

    /// Creates a new CustomAction action from the provided JavaScript code.
    /// - Parameter code: The code to execute.
    public init(_ code: String) {
        self.code = code
    }

    /// Renders this action using publishing context passed in.
    /// - Returns: The JavaScript for this action.
    public func compile() -> String {
        code.escapedForJavascript()
    }
}
