//
// FormFieldLabel.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `FormFieldLabel` element.
@Suite("Form Field Label Tests")
@MainActor
class FormFieldLabelTests: IgniteTestSuite {
    @Test("Basic Label")
    func basicLabel() async throws {
        let element = ControlLabel("This is a text for label")
        let output = element.markupString()

        #expect(output == "<label>This is a text for label</label>")
    }

    @Test("Label with inline element content")
    func labelWithInlineElementContent() async throws {
        let element = ControlLabel(Span("Email"))
        let output = element.markupString()
        #expect(output == "<label><span>Email</span></label>")
    }

    @Test("Label with class attribute")
    func labelWithClassAttribute() async throws {
        let element = ControlLabel("Name").class("form-label")
        let output = element.markupString()
        #expect(output.contains("class=\"form-label\""))
        #expect(output.contains("Name"))
        #expect(output.contains("<label"))
        #expect(output.contains("</label>"))
    }
}
