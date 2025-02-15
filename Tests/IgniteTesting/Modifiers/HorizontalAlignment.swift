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
    @Test("HorizontalAlignment Modifier for Text", arguments:
            [(HorizontalAlignment.leading, "text-start"),
             (HorizontalAlignment.center, "text-center"),
             (HorizontalAlignment.trailing, "text-end")
            ])
    func allAlignmentsForText(alignment: HorizontalAlignment, cssClass: String) async throws {
        let element = Text("Hello world!").horizontalAlignment(alignment)
        let output = element.render()
        #expect(
            output == "<p class=\"\(cssClass)\">Hello world!</p>"
        )
    }

    @Test("HorizontalAlignment Modifier for Text with medium responsive breakpoint", arguments:
            [(HorizontalAlignment.leading, "text-md-start"),
             (HorizontalAlignment.center, "text-md-center"),
             (HorizontalAlignment.trailing, "text-md-end")
            ])
    func allAlignmentsForTextResponsiveMedium(alignment: HorizontalAlignment, cssClass: String) async throws {
        let element = Text("Hello world!").horizontalAlignment(.responsive(medium: alignment))
        let output = element.render()
        #expect(
            output == "<p class=\"\(cssClass)\">Hello world!</p>"
        )
    }

    @Test("HorizontalAlignment Modifier for Text with all responsive breakpoints", arguments:
            [(HorizontalAlignment.leading, "text-start text-md-start text-lg-start text-xl-start text-xxl-start"),
             (HorizontalAlignment.center, "text-center text-md-center text-lg-center text-xl-center text-xxl-center"),
             (HorizontalAlignment.trailing, "text-end text-md-end text-lg-end text-xl-end text-xxl-end")
            ])
    func allAlignmentsForTextResponsiveAll(alignment: HorizontalAlignment, cssClass: String) async throws {
        let element = Text("Hello world!").horizontalAlignment(.responsive(small: alignment,
                                                                           medium: alignment,
                                                                           large: alignment,
                                                                           xLarge: alignment,
                                                                           xxLarge: alignment))
        let output = element.render()
        #expect(
            output == "<p class=\"\(cssClass)\">Hello world!</p>"
        )
    }

    @Test("HorizontalAlignment Modifier for Text with mixed responsive breakpoints")
    func allAlignmentsForTextResponsiveMixed() async throws {
        let element = Text("Hello world!")
            .horizontalAlignment(.responsive(small: .leading, medium: .center, large: .trailing))
        let output = element.render()
        #expect(
            output == "<p class=\"text-start text-md-center text-lg-end\">Hello world!</p>"
        )
    }

    @Test("HorizontalAlignment Modifier for Column", arguments:
            [(HorizontalAlignment.leading, "text-start"),
             (HorizontalAlignment.center, "text-center"),
             (HorizontalAlignment.trailing, "text-end")
            ])
    func allAlignmentsForColumn(alignment: HorizontalAlignment, cssClass: String) async throws {
        let element = Column {
            Label(text: "Left Label")
            Label(text: "Right Label")
        }.horizontalAlignment(alignment)
        let output = element.render()
        #expect(
            output == "<td colspan=\"1\" class=\"\(cssClass)\"><label>Left Label</label><label>Right Label</label></td>"
        )
    }

    @Test("HorizontalAlignment Modifier for Column with mixed responsive breakpoints")
    func allAlignmentsForColumnResponsiveMixed() async throws {
        let element = Column {
            Label(text: "Left Label")
            Label(text: "Right Label")
        }.horizontalAlignment(.responsive(small: .leading, medium: .center, large: .trailing))
        let output = element.render()
        #expect(
            output == """
                      <td colspan=\"1\" class=\"text-start text-md-center text-lg-end\">\
                      <label>Left Label</label><label>Right Label</label></td>
                      """
        )
    }
}
