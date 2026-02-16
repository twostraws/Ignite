//
//  ButtonGroup.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `ButtonGroup` element.
@Suite("ButtonGroup Tests")
@MainActor
class ButtonGroupTests: IgniteTestSuite {
    @Test("ButtonGroup renders with btn-group class")
    func hasBtnGroupClass() async throws {
        let group = ButtonGroup(accessibilityLabel: "Actions") {
            Button("OK")
        }

        let output = group.markupString()

        #expect(output.contains(#"class="btn-group"#))
    }

    @Test("ButtonGroup renders with group role")
    func hasGroupRole() async throws {
        let group = ButtonGroup(accessibilityLabel: "Actions") {
            Button("OK")
        }

        let output = group.markupString()

        #expect(output.contains(#"role="group""#))
    }

    @Test("ButtonGroup renders accessibility label in aria-label")
    func hasAriaLabel() async throws {
        let group = ButtonGroup(accessibilityLabel: "Editing tools") {
            Button("Cut")
            Button("Copy")
        }

        let output = group.markupString()

        #expect(output.contains(#"aria-label="Editing tools""#))
    }

    @Test("ButtonGroup contains rendered buttons")
    func containsButtons() async throws {
        let group = ButtonGroup(accessibilityLabel: "Actions") {
            Button("Save")
            Button("Cancel")
        }

        let output = group.markupString()

        #expect(output.contains("Save"))
        #expect(output.contains("Cancel"))
    }
}
