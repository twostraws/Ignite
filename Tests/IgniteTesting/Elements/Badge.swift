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
struct BadgeTests {
    @Test("All roles for default badge variant rendered correctly", arguments: zip(await Role.badgeRoles, [
        "text-bg-primary",
        "text-bg-secondary",
        "text-bg-success",
        "text-bg-danger",
        "text-bg-warning",
        "text-bg-info",
        "text-bg-light",
        "text-bg-dark"
    ]))
    func allRolesForDefaultBadgeVariant(role: Role, cssClass: String) async throws {
        let element = Text {
            Badge("Some text")
                .role(role)
        }
        let output = element.render()

        #expect(output == "<p><span class=\"badge rounded-pill \(cssClass)\">Some text</span></p>")
    }

    @Test("All roles for subtle badge variant rendered correctly", arguments: zip(await Role.badgeRoles, [
        "bg-primary-subtle rounded-pill text-primary-emphasis",
        "bg-secondary-subtle rounded-pill text-secondary-emphasis",
        "bg-success-subtle rounded-pill text-success-emphasis",
        "bg-danger-subtle rounded-pill text-danger-emphasis",
        "bg-warning-subtle rounded-pill text-warning-emphasis",
        "bg-info-subtle rounded-pill text-info-emphasis",
        "bg-light-subtle rounded-pill text-light-emphasis",
        "bg-dark-subtle rounded-pill text-dark-emphasis"
    ]))
    func allRolesForSubtleBadgeVariant(role: Role, cssClasses: String) async throws {
        let element = Text {
            Badge("Some text")
                .badgeStyle(.subtle)
                .role(role)
        }
        let output = element.render()

        #expect(output == "<p><span class=\"badge \(cssClasses)\">Some text</span></p>")
    }

    @Test("All roles for subtleBordered badge variant rendered correctly", arguments: zip(await Role.badgeRoles, [
        "bg-primary-subtle border border-primary-subtle rounded-pill text-primary-emphasis",
        "bg-secondary-subtle border border-secondary-subtle rounded-pill text-secondary-emphasis",
        "bg-success-subtle border border-success-subtle rounded-pill text-success-emphasis",
        "bg-danger-subtle border border-danger-subtle rounded-pill text-danger-emphasis",
        "bg-warning-subtle border border-warning-subtle rounded-pill text-warning-emphasis",
        "bg-info-subtle border border-info-subtle rounded-pill text-info-emphasis",
        "bg-light-subtle border border-light-subtle rounded-pill text-light-emphasis",
        "bg-dark-subtle border border-dark-subtle rounded-pill text-dark-emphasis"
    ]))
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
