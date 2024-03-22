//
// EmptyTagPage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A default tag page that does nothing; used to disable tag pages entirely.
public struct EmptyTagPage: TagPage {
    public init() { }

    public func body(tag: String?, context: PublishingContext) -> [any BlockElement] { }
}
