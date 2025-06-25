//
// TagMetadata.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Metadata for a tag used in content organization.
public struct TagMetadata: Sendable {
    /// The display name of the tag.
    public var name: String
    /// A path to the tag's corresponding tag page.
    public var path: String
}
