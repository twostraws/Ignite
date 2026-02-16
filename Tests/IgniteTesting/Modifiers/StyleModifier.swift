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

/// A test style whose name does not end in "Style".
private struct HighlightedCard: Style {
    func style(content: StyledHTML, environment: EnvironmentConditions) -> StyledHTML {
        content.style(.background, "yellow")
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

    @Test("Class name appends Style suffix when type name lacks it")
    func classNameAppendsSuffixWhenMissing() async throws {
        let style = HighlightedCard()
        #expect(style.className == "highlighted-card-style")
    }

    @Test("Different styles produce distinct class names")
    func differentStylesProduceDistinctClassNames() async throws {
        let a = TestCardStyle()
        let b = HighlightedCard()
        #expect(a.className != b.className)
    }

    // MARK: - StyledHTML

    @Test("StyledHTML style with Property accumulates inline styles")
    func styledHTMLStyleWithProperty() async throws {
        let styled = StyledHTML()
            .style(.color, "red")
            .style(.padding, "10px")
        #expect(styled.attributes.styles.count == 2)
    }

    @Test("StyledHTML style values are preserved")
    func styledHTMLStyleValuesPreserved() async throws {
        let styled = StyledHTML().style(.color, "blue")
        let styles = styled.attributes.styles
        #expect(styles.contains(InlineStyle(.color, value: "blue")))
    }

    @Test("StyledHTML array overload appends multiple styles")
    func styledHTMLArrayOverload() async throws {
        let styled = StyledHTML().style([
            InlineStyle(.color, value: "red"),
            InlineStyle(.padding, value: "5px")
        ])
        #expect(styled.attributes.styles.count == 2)
    }

    @Test("StyledHTML variadic overload appends styles")
    func styledHTMLVariadicOverload() async throws {
        let styled = StyledHTML().style(
            InlineStyle(.color, value: "red"),
            InlineStyle(.cursor, value: "pointer")
        )
        #expect(styled.attributes.styles.count == 2)
    }
}
