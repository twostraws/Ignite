//
//  Alert.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Alert` element.
@Suite("Alert Tests")
@MainActor
class AlertTests: IgniteTestSuite {
    @Test("All Alert roles are correctly set", arguments: zip(Role.standardRoles, [
        "alert-primary",
        "alert-secondary",
        "alert-success",
        "alert-danger",
        "alert-warning",
        "alert-info",
        "alert-light",
        "alert-dark"]))
    func allRolesForAlertVariant(role: Role, cssAppliedClass: String) async throws {
        let element = Alert {
            Text("This is not an exercice")
        }.role(role)

        let output = element.markup()

        #expect(output.string == "<div class=\"alert \(cssAppliedClass)\"><p>This is not an exercice</p></div>")
    }

    @Test("Default role does not add a role class")
    func defaultRole() async throws {
        let element = Alert {
            Text("Hello")
        }
        let output = element.markup()
        #expect(output.string == "<div class=\"alert\"><p>Hello</p></div>")
    }

    @Test("Alert with multiple children renders all content")
    func multipleChildren() async throws {
        let element = Alert {
            Text("Line 1")
            Text("Line 2")
        }.role(.warning)
        let output = element.markupString()
        #expect(output.contains("<p>Line 1</p>"))
        #expect(output.contains("<p>Line 2</p>"))
        #expect(output.contains("alert-warning"))
    }

    @Test("Alert preserves custom attributes")
    func customAttributes() async throws {
        let element = Alert {
            Text("Important")
        }
        .role(.danger)
        .customAttribute(name: "data-dismissible", value: "true")
        let output = element.markupString()
        #expect(output.contains("data-dismissible=\"true\""))
        #expect(output.contains("alert-danger"))
    }

    @Test("Alert with ID includes id attribute")
    func idAttribute() async throws {
        let element = Alert {
            Text("Notice")
        }.id("my-alert")
        let output = element.markupString()
        #expect(output.contains("id=\"my-alert\""))
    }
}
