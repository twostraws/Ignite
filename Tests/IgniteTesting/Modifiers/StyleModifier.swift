//
//  StyleModifier.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// A test style for verifying the style modifier.
private struct TestCardStyle: Style {
    func style(content: StyledHTML, environment: EnvironmentConditions) -> StyledHTML {
        content.foregroundStyle(.red)
    }
}

/// Tests for the `StyleModifier`.
@Suite("StyleModifier Tests")
@MainActor
class StyleModifierTests: IgniteTestSuite {
    @Test("Style modifier applies CSS class name")
    func styleModifierAppliesCSSClassName() async throws {
        let element = Text("Hello").style(TestCardStyle())
        let output = element.markupString()
        #expect(output.contains("test-card-style"))
    }

    @Test("Style class name derives from type name")
    func styleClassNameDerivesFromTypeName() async throws {
        let style = TestCardStyle()
        #expect(style.className == "test-card-style")
    }
}
