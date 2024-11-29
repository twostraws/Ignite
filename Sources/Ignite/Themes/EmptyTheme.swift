//
// EmptyTheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A theme that applies almost no styling.
public struct EmptyTheme: Layout {
    public var body: some HTML {
        HTMLDocument {
            HTMLBody(for: page)
        }
    }

    public init() {}
}
