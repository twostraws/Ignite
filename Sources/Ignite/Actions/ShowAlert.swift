//
// ShowAlert.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Shows a browser alert dialog with an OK button.
public struct ShowAlert: Action {
    /// The text to show inside the alert
    var message: String

    /// Creates a new ShowAlert action with its message string.
    /// - Parameter message: The message text to show in the alert.
    public init(message: String) {
        self.message = message
    }

    /// Renders this action using publishing context passed in.
    /// - Returns: The JavaScript for this action.
    public func compile() -> String {
        "alert('\(message.escapedForJavascript())')"
    }
}
