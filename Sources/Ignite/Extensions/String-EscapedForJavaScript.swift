//
// String-EscapedForJavaScript.swift
// IgniteSamples
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public extension String {
    /// Allows user strings to be used inside generated JavaScript event code.
    func escapedForJavascript() -> String {
        self
            .replacing("'", with: "\\'")
            .replacing("\"", with: "&quot;")
    }
}
