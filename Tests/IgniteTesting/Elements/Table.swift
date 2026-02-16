//
//  Table.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

@Suite("Table Tests")
@MainActor
class TableTests: IgniteTestSuite {
    @Test func simpleTable() async throws {
        let element = Table { }
        let output = element.markupString()
        #expect(output == "<table class=\"table\"><tbody></tbody></table>")
    }

    @Test("Table with header renders thead")
    func tableWithHeader() async throws {
        let element = Table {
            Row {
                Column { "A" }
                Column { "B" }
            }
        } header: {
            "Name"
            "Value"
        }
        let output = element.markupString()
        #expect(output.contains("<thead><tr><th>Name</th><th>Value</th></tr></thead>"))
    }

    @Test("Table with rows renders content inside tbody")
    func tableWithRows() async throws {
        let element = Table {
            Row {
                Column { "Cell1" }
            }
        }
        let output = element.markupString()
        #expect(output.contains("<tbody>"))
        #expect(output.contains("Cell1"))
    }

    @Test("Striped rows style adds table-striped class")
    func stripedRowsStyle() async throws {
        let element = Table { }.tableStyle(.stripedRows)
        let output = element.markupString()
        #expect(output.contains("table-striped"))
        #expect(!output.contains("table-striped-columns"))
    }

    @Test("Striped columns style adds table-striped-columns class")
    func stripedColumnsStyle() async throws {
        let element = Table { }.tableStyle(.stripedColumns)
        let output = element.markupString()
        #expect(output.contains("table-striped-columns"))
    }

    @Test("Plain style adds no striping class")
    func plainStyle() async throws {
        let element = Table { }.tableStyle(.plain)
        let output = element.markupString()
        #expect(!output.contains("table-striped"))
    }

    @Test("Table border adds table-bordered class")
    func tableBorder() async throws {
        let element = Table { }.tableBorder(true)
        let output = element.markupString()
        #expect(output.contains("table-bordered"))
    }

    @Test("Accessibility label adds caption element")
    func accessibilityLabel() async throws {
        let element = Table { }.accessibilityLabel("Test caption")
        let output = element.markupString()
        #expect(output.contains("<caption>Test caption</caption>"))
    }

    // MARK: - Filter title

    @Test("Table with filter title renders input with igniteFilterTable")
    func filterTitle() async throws {
        let element = Table(filterTitle: "Search...") {
            Row { Column { "Cell" } }
        }
        let output = element.markupString()
        #expect(output.contains("placeholder=\"Search...\""))
        #expect(output.contains("igniteFilterTable"))
        #expect(output.contains("form-control mb-2"))
    }

    // MARK: - Sequence initializers

    @Test("Table from sequence renders rows")
    func sequenceInitializer() async throws {
        let items = ["Alice", "Bob"]
        let element = Table(items) { name in
            Row { Column { name } }
        }
        let output = element.markupString()
        #expect(output.contains("Alice"))
        #expect(output.contains("Bob"))
        #expect(output.contains("<tbody>"))
    }

    @Test("Table from sequence with header renders thead and rows")
    func sequenceInitializerWithHeader() async throws {
        let items = ["Alice", "Bob"]
        let element = Table(items) { name in
            Row { Column { name } }
        } header: {
            "Name"
        }
        let output = element.markupString()
        #expect(output.contains("<thead><tr><th>Name</th></tr></thead>"))
        #expect(output.contains("Alice"))
    }

    // MARK: - Combined options

    @Test("Table with border, striped rows, and caption combines all attributes")
    func combinedOptions() async throws {
        let element = Table { }
            .tableBorder(true)
            .tableStyle(.stripedRows)
            .accessibilityLabel("My Table")
        let output = element.markupString()
        #expect(output.contains("table-bordered"))
        #expect(output.contains("table-striped"))
        #expect(output.contains("<caption>My Table</caption>"))
    }
}
