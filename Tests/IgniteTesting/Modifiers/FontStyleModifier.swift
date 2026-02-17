//
//  FontStyleModifier.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `FontStyleModifier` modifier.
@Suite("FontStyleModifier Tests")
@MainActor
class FontStyleModifierTests: IgniteTestSuite {
    private static let tagBasedStyles: [Font.Style] = [
        .title1, .title2, .title3, .title4, .title5, .title6, .body
    ]

    @Test("Font Style", arguments: await tagBasedStyles)
    func fontStyle(style: Font.Style) async throws {
        let element = Text("Hello").font(style)
        let output = element.markupString()
        #expect(output == "<\(style.description)>Hello</\(style.description)>")
    }

    @Test("Lead style on Text adds lead class")
    func leadStyleOnText() async throws {
        let element = Text("Hello").font(.lead)
        let output = element.markupString()
        #expect(output.contains("lead"))
    }

    @Test("Small style on Text adds small class")
    func smallStyleOnText() async throws {
        let element = Text("Hello").font(.small)
        let output = element.markupString()
        #expect(output.contains("ig-text-small"))
    }

    @Test("Class-based styles on non-Text HTML use size class", arguments: [
        (Font.Style.lead, "lead"),
        (Font.Style.small, "ig-text-small"),
        (Font.Style.xSmall, "ig-text-xSmall"),
        (Font.Style.xxSmall, "ig-text-xxSmall"),
        (Font.Style.xxxSmall, "ig-text-xxxSmall")
    ])
    func classBasedStylesOnNonText(style: Font.Style, expectedClass: String) async throws {
        let element = Section { Text("Hello") }.font(style)
        let output = element.markupString()
        #expect(output.contains(expectedClass))
    }

    @Test("Title style on non-Text HTML uses size class instead of tag")
    func titleStyleOnNonText() async throws {
        let element = Section { Text("Hello") }.font(.title1)
        let output = element.markupString()
        #expect(output.contains("fs-1"))
    }

    @Test("Font style on inline element applies class")
    func fontStyleOnInlineElement() async throws {
        let element = Span("Hello").font(.lead)
        let output = element.markupString()
        #expect(output.contains("lead"))
    }
}
