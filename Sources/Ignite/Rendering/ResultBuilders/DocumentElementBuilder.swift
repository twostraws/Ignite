//
// DocumentElementBuilder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A result builder for populating the children of a `Document`.
@MainActor
@resultBuilder
public struct DocumentElementBuilder {
    /// Creates a tuple containing the provided head and body elements.
    /// - Parameters:
    ///   - head: The document's head section containing metadata.
    ///   - body: The document's body section containing main content.
    /// - Returns: A tuple containing the provided head and body elements.
    public static func buildBlock(_ head: Head, _ body: Body) -> (Head, Body) {
        (head, body)
    }

    /// Creates a tuple containing a default head and the provided body element.
    /// - Parameter body: The document's body section containing main content.
    /// - Returns: A tuple containing a default head and the provided body element.
    public static func buildBlock(_ body: Body) -> (Head, Body) {
        (Head(), body)
    }
}
