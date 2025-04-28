//
// DocumentBuilder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A result builder that enables declarative syntax for constructing layouts.
@MainActor
@resultBuilder
public struct DocumentBuilder {
    public static func buildBlock(_ head: Head, _ body: Body) -> Document {
        Document(head: head, body: body)
    }

    public static func buildBlock(_ body: Body) -> Document {
        Document(head: Head(), body: body)
    }
}

extension DocumentBuilder {
    static func buildBlock(_ component: Document) -> Document {
        component
    }
}
