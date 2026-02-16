//
//  ShowAlert.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `ShowAlert` action.
@Suite("ShowAlert Tests")
@MainActor
class ShowAlertTests: IgniteTestSuite {
    @Test("compile() wraps plain message in alert()")
    func plainMessage() async throws {
        let action = ShowAlert(message: "Hello")
        #expect(action.compile() == "alert('Hello')")
    }

    @Test("compile() escapes single quotes in the message")
    func singleQuotesEscaped() async throws {
        let action = ShowAlert(message: "It's a test")
        #expect(action.compile() == #"alert('It\'s a test')"#)
    }

    @Test("compile() escapes double quotes in the message")
    func doubleQuotesEscaped() async throws {
        let action = ShowAlert(message: #"She said "hi""#)
        #expect(action.compile() == "alert('She said &quot;hi&quot;')")
    }

    @Test("compile() produces empty alert for empty message")
    func emptyMessage() async throws {
        let action = ShowAlert(message: "")
        #expect(action.compile() == "alert('')")
    }
}
