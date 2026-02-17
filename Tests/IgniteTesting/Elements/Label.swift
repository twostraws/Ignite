//
// Label.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Label` element.
@Suite("Label Tests")
@MainActor
class LabelTests: IgniteTestSuite {
    @Test("Basic Label")
    func basicLabel() async throws {
        let element = Label("Logo", image: "/images/logo.png")
        let output = element.markupString()

        #expect(output == """
        <span style="display: inline-flex; align-items: center">\
        <img src="/images/logo.png" alt="Logo" style="margin-right: 10px" />\
        Logo\
        </span>
        """)
    }

    @Test("Label with system image uses Bootstrap icon")
    func systemImageLabel() async throws {
        let element = Label("Settings", systemImage: "gear")
        let output = element.markupString()
        #expect(output.contains("bi-gear"))
        #expect(output.contains("Settings"))
        #expect(output.contains("inline-flex"))
    }

    @Test("Label with builder initializer renders custom content")
    func builderLabel() async throws {
        let element = Label {
            Span("Custom Title")
        } icon: {
            Span("Icon")
        }
        let output = element.markupString()
        #expect(output.contains("Custom Title"))
        #expect(output.contains("Icon"))
        #expect(output.contains("inline-flex"))
    }
}
