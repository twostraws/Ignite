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
class ListItemTests: IgniteTestSuite {
    @Test("Standalone ListItem", .publishingContext())
    func standAlone() async throws {
        let element = ListItem {
            "Standalone List Item"
        }
        let output = element.markupString()

        #expect(output == "<li>Standalone List Item</li>")
    }

    @Test("ListItem with role adds role class", .publishingContext())
    func roleModifier() async throws {
        let element = ListItem {
            "Important item"
        }.role(.danger)
        let output = element.markupString()
        #expect(output.contains("list-group-item-danger"))
    }

    @Test("ListItem with HTML content renders nested elements", .publishingContext())
    func htmlContent() async throws {
        let element = ListItem {
            Text("Bold item")
            Text("Second line")
        }
        let output = element.markupString()
        #expect(output.contains("<p>Bold item</p>"))
        #expect(output.contains("<p>Second line</p>"))
        #expect(output.hasPrefix("<li>"))
    }
}
