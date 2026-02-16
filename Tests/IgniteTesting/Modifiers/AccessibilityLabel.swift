//
//  AccessibilityLabel.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `AccessibilityLabel` modifier.
@Suite("AccessibilityLabel Tests")
@MainActor
class AccessibilityLabelTests: IgniteTestSuite {
    @Test("accessibilityLabel adds aria-label to block element")
    func blockElement() async throws {
        let element = Text("Hello")
            .accessibilityLabel("greeting")

        let output = element.markupString()

        #expect(output.contains(#"aria-label="greeting""#))
    }

    @Test("accessibilityLabel adds aria-label to Section")
    func sectionElement() async throws {
        let element = Section {}
            .accessibilityLabel("main content")

        let output = element.markupString()

        #expect(output.contains(#"aria-label="main content""#))
    }
}
