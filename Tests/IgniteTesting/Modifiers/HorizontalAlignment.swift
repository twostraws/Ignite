//
//  HorizontalAlignment.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `HorizontalAlignment` modifier.
@Suite("HorizontalAlignment Tests")
@MainActor
struct HorizontalAlignmentTests {
    @Test("Text", arguments: zip(
        [HorizontalAlignment.leading, .center, .trailing],
        ["text-start", "text-center", "text-end"]))
    func allAlignmentsForText(alignment: HorizontalAlignment, cssClass: String) async throws {
        let element = Text("Hello world!").horizontalAlignment(alignment)
        let output = element.render()
        #expect(output == "<p class=\"\(cssClass)\">Hello world!</p>")
    }

    @Test("Text with medium responsive breakpoint", arguments: zip(
        [HorizontalAlignment.leading, .center, .trailing],
        ["text-md-start", "text-md-center", "text-md-end"]))
    func allAlignmentsForTextResponsiveMedium(alignment: HorizontalAlignment, cssClass: String) async throws {
        let element = Text("Hello world!").horizontalAlignment(.responsive(medium: alignment))
        let output = element.render()
        #expect(output == "<p class=\"\(cssClass)\">Hello world!</p>")
    }

    @Test("Text with all responsive breakpoints", arguments: zip(
        [HorizontalAlignment.leading, .center, .trailing],
        ["text-start",
         "text-center",
         "text-end"]))
    func allAlignmentsForTextResponsiveAll(alignment: HorizontalAlignment, cssClass: String) async throws {
        let element = Text("Hello world!")
            .horizontalAlignment(
                .responsive(
                    alignment,
                    small: alignment,
                    medium: alignment,
                    large: alignment,
                    xLarge: alignment,
                    xxLarge: alignment))

        let output = element.render()
        #expect(output == "<p class=\"\(cssClass)\">Hello world!</p>")
    }

    @Test("Text with mixed responsive breakpoints")
    func allAlignmentsForTextResponsiveMixed() async throws {
        let element = Text("Hello world!")
            .horizontalAlignment(.responsive(small: .leading, medium: .center, large: .trailing))
        let output = element.render()
        #expect(output == "<p class=\"text-start text-md-center text-lg-end\">Hello world!</p>")
    }

    @Test("Column", arguments: zip(
        [HorizontalAlignment.leading, .center, .trailing],
        ["text-start", "text-center", "text-end"]))
    func allAlignmentsForColumn(alignment: HorizontalAlignment, cssClass: String) async throws {
        let element = Column {
            FormFieldLabel(text: "Left Label")
            FormFieldLabel(text: "Right Label")
        }
        .horizontalAlignment(alignment)

        let output = element.render()

        #expect(output == """
        <td colspan=\"1\" class=\"\(cssClass)\">\
        <label>Left Label</label>\
        <label>Right Label</label>\
        </td>
        """)
    }

    @Test("Column with mixed responsive breakpoints")
    func allAlignmentsForColumnResponsiveMixed() async throws {
        let element = Column {
            FormFieldLabel(text: "Left Label")
            FormFieldLabel(text: "Right Label")
        }
        .horizontalAlignment(.responsive(small: .leading, medium: .center, large: .trailing))

        let output = element.render()

        #expect(output == """
        <td colspan=\"1\" class=\"text-start text-md-center text-lg-end\">\
        <label>Left Label</label><label>Right Label</label></td>
        """)
    }
}
