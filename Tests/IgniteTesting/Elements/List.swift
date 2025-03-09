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
        let output = list.render()
        #expect(output == "<ul></ul>")
    }

    @Test("Basic Unordered List")
       func unorderedList() async throws {
           let list = List {
               "Veni"
               "Vidi"
               "Vici"
           }
           let output = list.render()

           #expect(output == "<ul><li>Veni</li><li>Vidi</li><li>Vici</li></ul>")
       }
}
