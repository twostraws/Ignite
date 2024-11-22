//
// Array-Content.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension Array where Element == Content {
    /// Returns all content tagged with the specified type, or all content if the type is nil.
    /// - Parameter type: The type to filter by, or nil for all content.
    /// - Returns: An array of content matching the specified type, or all content
    /// if no type was specified.
    @MainActor func callAsFunction(ofType type: String?) -> Self {
        if let type {
            self.filter { $0.type == type }
        } else {
            self
        }
    }
}
