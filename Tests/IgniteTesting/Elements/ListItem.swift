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
class ListItemTests: IgniteTestSuite {
    @Test("Standalone ListItem")
    func standAlone() async throws {
        let element = ListItem {
            "Standalone List Item"
        }
        let output = element.render()

        #expect(output == "<li>Standalone List Item</li>")
    }
}
