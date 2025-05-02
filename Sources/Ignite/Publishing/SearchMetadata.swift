//
// SearchMetadata.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Metadata for a searchable document, containing its unique identifier,
/// title, description, and optional tags and date.
struct SearchMetadata: Sendable {
    /// A unique identifier for the document.
    var id: String

    /// The document's title.
    var title: String

    /// A brief description of the document's contents.
    var description: String

    /// Tags that categorize the document.
    var tags: [String]?

    /// When the document was created or last modified.
    var date: Date?
}
