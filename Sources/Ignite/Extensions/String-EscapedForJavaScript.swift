//
//  File.swift
//  
//
//  Created by Paul Hudson on 28/03/2024.
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
