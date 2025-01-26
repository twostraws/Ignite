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
struct ListTests {
    @Test("Basic Rendering Test")
    func testEmptyListRendering() async throws {
        let list = List {}
        let output = list.render()

        #expect(output == "<ul><li></li></ul>")
    }

    @Test("Basic Unordered List Test")
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
