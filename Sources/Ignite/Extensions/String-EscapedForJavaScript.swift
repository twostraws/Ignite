//
// String-EscapedForJavaScript.swift
// IgniteSamples
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension String {
    /// Allows user strings to be used inside generated JavaScript event code.
    public func escapedForJavascript() -> String {
        self
            .replacing("'", with: "\\'")
            .replacing("\"", with: "&quot;")
    }
}
