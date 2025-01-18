//
// InlineHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An element that exists inside a block element, such as an emphasized
/// piece of text.
public protocol InlineHTML: HTML, CustomStringConvertible {}

public extension InlineHTML {
    /// A string that enables `InlineHTML` elements to be used in
    /// string interpolation by rendering without a publishing context.
    nonisolated var description: String {
        return MainActor.assumeIsolated {
            self.render(context: nil)
        }
    }
}
