//
//  ListItem.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `ListItem` element.
@Suite("ListItem Tests")
@MainActor
struct ListItemTests {
    @Test("Standalone ListItem Test")
    func standAlone() async throws {
        let element = ListItem {
            "Standalone List Item"
        }
        let output = element.render()
        #expect(output == "<li>Standalone List Item</li>")
    }
}
