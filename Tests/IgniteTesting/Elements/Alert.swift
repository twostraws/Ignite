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
    @Test("All Alert roles are correctly set", arguments: zip(await Role.badgeRoles, [
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

        let output = element.render()

        #expect(output == "<div class=\"alert \(cssAppliedClass)\"><p>This is not an exercice</p></div>")
    }
}
