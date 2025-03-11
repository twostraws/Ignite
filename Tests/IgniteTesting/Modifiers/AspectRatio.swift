//
//  AspectRatio.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `AspectRatio` modifier.
@Suite("AspectRatio Tests")
@MainActor
class AspectRatioTests: IgniteTestSuite {
    @Test("Verify AspectRatio Modifiers", arguments: AspectRatio.allCases)
    func verifyAspectRatioModifiers(ratio: AspectRatio) async throws {
        let element = Text("Hello").aspectRatio(ratio)
        let output = element.render()

        #expect(output == "<p class=\"ratio ratio-\(ratio.rawValue)\">Hello</p>")
    }

    @Test("Verify Content Modes", arguments: AspectRatio.allCases, ContentMode.allCases)
    func verifyContentModes(ratio: AspectRatio, mode: ContentMode) async throws {
        let element = Image("/images/example.jpg").aspectRatio(ratio, contentMode: mode)
        let output = element.render()

        #expect(output == """
        <div class="ratio ratio-\(ratio.rawValue)">\
        <img src="/images/example.jpg" alt="" class="\(mode.htmlClass)" /></div>
        """)
    }
}
