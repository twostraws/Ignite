//
//  Badge.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Badge` element.
@Suite("Badge Tests")
@MainActor
class BadgeTests: IgniteTestSuite {
    @Test("All roles for default badge variant rendered correctly", arguments: zip(await Role.badgeRoles, [
        "text-bg-primary",
        "text-bg-secondary",
        "text-bg-success",
        "text-bg-danger",
        "text-bg-warning",
        "text-bg-info",
        "text-bg-light",
        "text-bg-dark"]))
    func allRolesForDefaultBadgeVariant(role: Role, cssClass: String) async throws {
        let element = Text {
            Badge("Some text")
                .role(role)
        }

        let output = element.render()
        #expect(output == "<p><span class=\"badge \(cssClass) rounded-pill\">Some text</span></p>")
    }

    @Test("All roles for subtle badge variant rendered correctly", arguments: zip(await Role.badgeRoles, [
        "bg-primary-subtle text-primary-emphasis rounded-pill",
        "bg-secondary-subtle text-secondary-emphasis rounded-pill",
        "bg-success-subtle text-success-emphasis rounded-pill",
        "bg-danger-subtle text-danger-emphasis rounded-pill",
        "bg-warning-subtle text-warning-emphasis rounded-pill",
        "bg-info-subtle text-info-emphasis rounded-pill",
        "bg-light-subtle text-light-emphasis rounded-pill",
        "bg-dark-subtle text-dark-emphasis rounded-pill"]))
    func allRolesForSubtleBadgeVariant(role: Role, cssClasses: String) async throws {
        let element = Text {
            Badge("Some text")
                .role(role)
                .badgeStyle(.subtle)
        }

        let output = element.render()
        #expect(output == "<p><span class=\"badge \(cssClasses)\">Some text</span></p>")
    }

    @Test("All roles for subtleBordered badge variant rendered correctly", arguments: zip(await Role.badgeRoles, [
        "bg-primary-subtle border border-primary-subtle text-primary-emphasis rounded-pill",
        "bg-secondary-subtle border border-secondary-subtle text-secondary-emphasis rounded-pill",
        "bg-success-subtle border border-success-subtle text-success-emphasis rounded-pill",
        "bg-danger-subtle border border-danger-subtle text-danger-emphasis rounded-pill",
        "bg-warning-subtle border border-warning-subtle text-warning-emphasis rounded-pill",
        "bg-info-subtle border border-info-subtle text-info-emphasis rounded-pill",
        "bg-light-subtle border border-light-subtle text-light-emphasis rounded-pill",
        "bg-dark-subtle border border-dark-subtle text-dark-emphasis rounded-pill"]))
    func allRolesForSubtleBorderedBadgeVariant(role: Role, cssClasses: String) async throws {
        let element = Text {
            Badge("Some text")
                .badgeStyle(.subtleBordered)
                .role(role)
        }

        let output = element.render()
        #expect(output == "<p><span class=\"badge \(cssClasses)\">Some text</span></p>")
    }
}
