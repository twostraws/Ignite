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
    public static func buildBlock(_ components: any DocumentElement...) -> some HTML {
        Document {
            // If no HTMLHead is provided, add a default one
            if !components.contains(where: { $0 is Head }) {
                Head()
            }

            // Add all provided components
            for component in components {
                component
            }
        }
    }
}

extension DocumentBuilder {
    static func buildBlock(_ component: Document) -> Document {
        component
    }
}
