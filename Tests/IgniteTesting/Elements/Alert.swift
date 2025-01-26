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
struct AlertTests {
    @Test("Test Alert with primary role", arguments: ["This alert has the primary role."])
    func alertWithPrimaryRole(alertPrimaryText: String) async throws {
        let element = Alert {
            Text("\(alertPrimaryText)")
        }.role(.primary)
        let output = element.render()

        #expect(output == "<div class=\"alert alert-primary\"><p>This alert has the primary role.</p></div>")
    }

    @Test("Test Alert with secondary role", arguments: ["This alert has the secondary role."])
    func alertWithSecondaryRole(alertSecondaryText: String) async throws {
        let element = Alert {
            Text("\(alertSecondaryText)")
        }.role(.secondary)
        let output = element.render()

        #expect(output == "<div class=\"alert alert-secondary\"><p>This alert has the secondary role.</p></div>")
    }

    @Test("Test Alert with success role", arguments: ["This alert has the success role."])
    func alertWithSuccessRole(alertSuccessText: String) async throws {
        let element = Alert {
            Text("\(alertSuccessText)")
        }.role(.success)
        let output = element.render()

        #expect(output == "<div class=\"alert alert-success\"><p>This alert has the success role.</p></div>")
    }

    @Test("Test Alert with danger role", arguments: ["This alert has the danger role."])
    func alertWithDangerRole(alertDangerText: String) async throws {
        let element = Alert {
            Text("\(alertDangerText)")
        }.role(.danger)
        let output = element.render()

        #expect(output == "<div class=\"alert alert-danger\"><p>This alert has the danger role.</p></div>")
    }

    @Test("Test Alert with warning role", arguments: ["This alert has the warning role."])
    func alertWithWarningRole(alertWarningText: String) async throws {
        let element = Alert {
            Text("\(alertWarningText)")
        }.role(.warning)
        let output = element.render()

        #expect(output == "<div class=\"alert alert-warning\"><p>This alert has the warning role.</p></div>")
    }

    @Test("Test Alert with info role", arguments: ["This alert has the info role."])
    func alertWithInfoRole(alertInfoText: String) async throws {
        let element = Alert {
            Text("\(alertInfoText)")
        }.role(.info)
        let output = element.render()

        #expect(output == "<div class=\"alert alert-info\"><p>This alert has the info role.</p></div>")
    }

    @Test("Test Alert with light role", arguments: ["This alert has the light role."])
    func alertWithLightRole(alertLightText: String) async throws {
        let element = Alert {
            Text("\(alertLightText)")
        }.role(.light)
        let output = element.render()

        #expect(output == "<div class=\"alert alert-light\"><p>This alert has the light role.</p></div>")
    }

    @Test("Test Alert with dark role", arguments: ["This alert has the dark role."])
    func alertWithDarkRole(alertDarkText: String) async throws {
        let element = Alert {
            Text("\(alertDarkText)")
        }.role(.dark)
        let output = element.render()

        #expect(output == "<div class=\"alert alert-dark\"><p>This alert has the dark role.</p></div>")
    }
}
