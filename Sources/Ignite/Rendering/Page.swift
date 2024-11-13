//
// Page.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A single flattened page from any source – static or dynamic – ready to be
/// passed through a theme.
public struct Page: Sendable {
    private(set) public var title: String
    private(set) public var description: String
    private(set) public var url: URL
    private(set) public var image: URL?
    private(set) public var body: any HTML
}

extension Page {
    /// Creates an empty page for use as a default value
    @MainActor static let empty = Page(
        title: "",
        description: "",
        url: URL(string: "about:blank")!,
        body: EmptyHTML()
    )
}
