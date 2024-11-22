//
// ContentContext.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Manages the current Markdown content during HTML rendering
@MainActor
final class ContentContext {
    /// The current Markdown content being rendered
    static var current: Content = .empty

    /// Temporarily sets new current Markdown content for the duration of an operation
    /// - Parameters:
    ///   - content: The content to set as current
    ///   - operation: The work to perform with the temporary content
    /// - Returns: The result of the operation
    static func withCurrentContent<Result>(_ content: Content, operation: () throws -> Result) rethrows -> Result {
        let previous = current
        current = content
        defer { current = previous }
        return try operation()
    }
}
