//
//  List.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `List` element.
@Suite("List Tests")
@MainActor
class ListTests: IgniteTestSuite {
    @Test("Basic Rendering")
    func testEmptyListRendering() async throws {
        let list = List {}
        let output = list.markupString()
        #expect(output == "<ul></ul>")
    }

    @Test("Basic Unordered List")
       func unorderedList() async throws {
           let list = List {
               "Veni"
               "Vidi"
               "Vici"
           }
           let output = list.markupString()

           #expect(output == "<ul><li>Veni</li><li>Vidi</li><li>Vici</li></ul>")
       }

    @Test("Ordered list uses ol tag")
    func orderedList() async throws {
        let list = List {
            "First"
            "Second"
        }.listMarkerStyle(.ordered)
        let output = list.markupString()
        #expect(output.hasPrefix("<ol"))
        #expect(output.hasSuffix("</ol>"))
        #expect(output.contains("First"))
    }

    @Test("Group list style adds list-group class")
    func groupListStyle() async throws {
        let list = List {
            "Item"
        }.listStyle(.group)
        let output = list.markupString()
        #expect(output.contains("list-group"))
        #expect(output.contains("list-group-item"))
    }

    @Test("Plain list style adds list-group-flush class")
    func plainListStyle() async throws {
        let list = List {
            "Item"
        }.listStyle(.plain)
        let output = list.markupString()
        #expect(output.contains("list-group-flush"))
    }

    @Test("Horizontal group list style adds list-group-horizontal class")
    func horizontalGroupListStyle() async throws {
        let list = List {
            "Item"
        }.listStyle(.horizontalGroup)
        let output = list.markupString()
        #expect(output.contains("list-group-horizontal"))
    }

    @Test("Custom marker style converts symbol to CSS unicode")
    func customMarkerStyle() async throws {
        let list = List {
            "Starred"
        }.listMarkerStyle(.custom("★"))
        let output = list.markupString()
        #expect(output.contains("list-style-type"))
    }

    @Test("Sequence initializer renders items from collection")
    func sequenceInitializer() async throws {
        let names = ["Alice", "Bob"]
        let list = List(names) { name in
            Text(name)
        }
        let output = list.markupString()
        #expect(output.contains("Alice"))
        #expect(output.contains("Bob"))
    }

    @Test("Ordered list with specific marker style applies style")
    func orderedListWithRomanMarker() async throws {
        let list = List {
            "Item"
        }.listMarkerStyle(.ordered(.upperRoman))
        let output = list.markupString()
        #expect(output.hasPrefix("<ol"))
        #expect(output.contains("list-style-type: upper-roman"))
    }
}
