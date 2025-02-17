//
//  Row.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Row` element.
@Suite("Row Tests")
@MainActor
struct RowTests {
    @Test("Row with Multiple Columns")
    func rowWithMultipleColumns() async throws {
        let row = Row {
            Text("Column 1")
            Text("Column 2")
        }
        let output = row.render()

        #expect(output == "<tr><td><p>Column 1</p></td><td><p>Column 2</p></td></tr>")
    }

    @Test("Row with Column Elements")
    func rowWithColumnElements() async throws {
        let row = Row {
            Column { Text("Column 1") }
            Column { Text("Column 2") }
        }
        let output = row.render()

        #expect(output == "<tr><td colspan=\"1\"><p>Column 1</p></td><td colspan=\"1\"><p>Column 2</p></td></tr>")
    }

    @Test("Row with Mixed Content")
    func rowWithMixedContent() async throws {
        let row = Row {
            Text("Column 1")
            Column { Text("Column 2") }
        }
        let output = row.render()

        #expect(output == "<tr><td><p>Column 1</p></td><td colspan=\"1\"><p>Column 2</p></td></tr>")
    }
}
