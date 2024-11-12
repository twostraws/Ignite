//
// TagContext.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Manages the current tag during page generation
@MainActor
final class TagContext {
    static var current: String?

    /// Temporarily sets a new current tag for the duration of an operation
    /// - Parameters:
    ///   - tag: The tag to set as current
    ///   - operation: The work to perform while the tag is set as current
    /// - Returns: The result of the operation
    static func withCurrentTag<T>(_ tag: String?, operation: () -> T) -> T {
        let previous = current
        current = tag
        defer { current = previous }
        return operation()
    }
}
