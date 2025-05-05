//
// DocumentBuilder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A result builder for constructing HTML documents.
///
/// When provided with individual `Head` and `Body` elements, `@DocumentBuilder`
/// wraps them in a `PlainDocument`. It also supports creating a document with
/// just a `Body` (inferring a default head) or accepting a `Document` directly.
@MainActor
@resultBuilder
public struct DocumentBuilder {
    /// Creates a document by wrapping the provided head and body in a `PlainDocument`.
    /// - Parameters:
    ///   - head: The document's head section containing metadata.
    ///   - body: The document's body section containing main content.
    /// - Returns: A new `PlainDocument` containing the provided head and body.
    public static func buildBlock(_ head: Head, _ body: Body) -> some Document {
        PlainDocument(head: head, body: body)
    }

    /// Creates a document by wrapping the provided body in a `PlainDocument` with a default head.
    /// - Parameter body: The document's body section containing main content.
    /// - Returns: A new `PlainDocument` with a default head and the provided body.
    public static func buildBlock(_ body: Body) -> some Document {
        PlainDocument(head: Head(), body: body)
    }

    /// Creates a document from an existing document component.
    /// - Parameter component: A complete document component.
    /// - Returns: The provided document component unchanged.
    public static func buildBlock<Content: Document>(_ component: Content) -> some Document {
        component
    }
}
