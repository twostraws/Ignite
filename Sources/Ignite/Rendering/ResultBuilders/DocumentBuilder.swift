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
            let (header, components) = components.reduce(
                into: (header: Head, components: [any DocumentElement])(Head(), [])
            ) { partialResult, element in
                if let header = element as? Head {
                    // In case multiple headers were provided only lat one will be used
                    partialResult.header = header
                } else {
                    partialResult.components.append(element)
                }
            }
            
            header

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
