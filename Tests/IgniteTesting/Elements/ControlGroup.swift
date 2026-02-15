//
//  ControlGroup.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `ControlGroup` element.
@Suite("ControlGroup Tests")
@MainActor
class ControlGroupTests: IgniteTestSuite {
    @Test("Basic control group has input-group class")
    func basicControlGroupHasInputGroupClass() async throws {
        let element = ControlGroup {
            TextField("Name", prompt: "Enter name")
                .id("name")
        }

        let output = element.markupString()
        #expect(output.contains("input-group"))
    }

    @Test("Control group with label renders label element")
    func controlGroupWithLabelRendersLabelElement() async throws {
        let element = ControlGroup("Full Name") {
            TextField("Name", prompt: "Enter name")
                .id("name")
        }

        let output = element.markupString()
        #expect(output.contains("Full Name"))
        #expect(output.contains("form-label"))
    }

    @Test("Control size small", arguments: zip(
        ControlGroup.ControlSize.allCases,
        ["input-group-sm", "", "input-group-lg"]))
    func controlSizeClasses(
        size: ControlGroup.ControlSize,
        expectedClass: String
    ) async throws {
        #expect(size.rawValue == expectedClass)
    }

    @Test("Control group with help text renders form-text")
    func controlGroupWithHelpTextRendersFormText() async throws {
        let element = ControlGroup("Email") {
            TextField("Email", prompt: "Enter email")
                .id("email")
        }
        .helpText("We'll never share your email.")

        let output = element.markupString()
        #expect(output.contains("form-text"))
        #expect(output.contains("We\u{2019}ll never share your email.") ||
                output.contains("We'll never share your email."))
    }

    @Test("Control group with span renders input-group-text")
    func controlGroupWithSpanRendersInputGroupText() async throws {
        let element = ControlGroup {
            Span("@")
            TextField("Username", prompt: "Enter username")
                .id("username")
        }

        let output = element.markupString()
        #expect(output.contains("input-group-text"))
        #expect(output.contains("@"))
    }
}
