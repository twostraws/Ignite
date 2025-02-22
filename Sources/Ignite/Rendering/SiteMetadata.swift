//
// SiteMetadata.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The core metadata of your website, such as name, description, and URL.
public struct SiteMetadata: Sendable {
    /// The name of the site
    private(set) public var name: String

    /// A string to append to the end of page titles
    private(set) public var titleSuffix: String

    /// An optional description for the site
    private(set) public var description: String?

    /// The base URL for the site
    private(set) public var url: URL
}

extension SiteMetadata {
    /// Creates an empty page for use as a default value
    @MainActor static let empty = SiteMetadata(
        name: "",
        titleSuffix: "",
        description: "",
        url: URL(string: "about:blank")!
    )
}
