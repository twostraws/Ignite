//
// EmptyTagPage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A default tag page that does nothing; used to disable tag pages entirely.
public struct EmptyTagPage: TagPage {
    public var body: some HTML {
        EmptyHTML()
    }
}
