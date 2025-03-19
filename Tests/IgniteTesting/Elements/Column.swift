//
//  Column.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Column` element.
@Suite("Column Tests")
@MainActor
class ColumnTests: IgniteTestSuite {
    static let columnSpans: [Int] = [0, 1, 10, 100]

    @Test("Column with items")
    func basicColumn() async throws {
        let element = Column {
            FormFieldLabel(text: "Left Label")
            FormFieldLabel(text: "Middle Label")
            FormFieldLabel(text: "Right Label")
        }

        let output = element.render()

        #expect(output == """
        <td colspan="1"><label>Left Label</label><label>Middle Label</label><label>Right Label</label></td>
        """)
    }

    @Test("Column with columnSpan", arguments: await Self.columnSpans)
    func columnWithColumnSpan(columnSpan: Int) async throws {
        let element = Column {
            FormFieldLabel(text: "Left Label")
            FormFieldLabel(text: "Middle Label")
            FormFieldLabel(text: "Right Label")
        }.columnSpan(columnSpan)

        let output = element.render()

        #expect(output == """
        <td colspan="\(columnSpan)"><label>Left Label</label><label>Middle Label</label><label>Right Label</label></td>
        """)
    }

    @Test("Column with vertical alignment", arguments: Column.VerticalAlignment.allCases)
    func columnWithVerticalAlignment(alignment: Column.VerticalAlignment) async throws {
        let element = Column {
            FormFieldLabel(text: "Left Label")
            FormFieldLabel(text: "Middle Label")
            FormFieldLabel(text: "Right Label")
        }.verticalAlignment(alignment)

        let output = element.render()

        if alignment != .top {
            #expect(output == """
            <td colspan="1" class="align-\(alignment)">\
            <label>Left Label</label><label>Middle Label</label><label>Right Label</label></td>
            """)
        } else {
            #expect(output == """
            <td colspan="1"><label>Left Label</label><label>Middle Label</label><label>Right Label</label></td>
            """)
        }
    }
}
