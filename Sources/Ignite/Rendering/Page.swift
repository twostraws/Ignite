//
// Page.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A single flattened page from any source – static or dynamic – ready to be
/// passed through a theme.
public struct Page {
    private(set) public var title: String
    private(set) public var description: String
    private(set) public var url: URL
    private(set) public var image: URL?
    private(set) public var body: any BlockElement
}
