//
//  Tag.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Tag` element.
@Suite("Tag Tests")
@MainActor
struct TagTests {
    @Test("Basic Tag", arguments: ["tag_1", "tag_2", "tag_3"])
    func basicTag(tagName: String) async throws {
        let element = Tag(tagName)
        let output = element.render()

        #expect(output == "<\(tagName)></\(tagName)>")
    }
}
