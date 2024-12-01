//
// EmptyTagLayout.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A default tag layout that does nothing; used to disable tag pages entirely.
public struct EmptyTagLayout: TagLayout {
    public init() {}

    public var body: some HTML {
        EmptyBlockElement()
    }
}
