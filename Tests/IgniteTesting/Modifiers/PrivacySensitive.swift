//
//  PrivacySensitive.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `PrivacySensitive` modifier.
@Suite("PrivacySensitive Tests")
@MainActor
struct PrivacySensitiveTests {
    @Test("Default privacySensitive defaults to urlOnly")
    func defaultPrivacySensitive() async throws {
        let element = Link("Go Home", target: "/").privacySensitive()
        let output = element.render()

        #expect(output.contains("privacy-sensitive=\"urlOnly\""))
        #expect(output.contains("protected-link"))
    }

    @Test("privacySensitive modifier with urlOnly encoding")
    func privacySensitiveWithURLOnly() async throws {
        let element = Link("Go Home", target: "/").privacySensitive(.urlOnly)
        let output = element.render()

        #expect(output.contains("privacy-sensitive=\"urlOnly\""))
        #expect(output.contains("protected-link"))
    }

    @Test("privacySensitive modifier with urlAndDisplay encoding")
    func privacySensitiveWithURLAndDisplay() async throws {
        let element = Link("Go Home", target: "/").privacySensitive(.urlAndDisplay)
        let output = element.render()

        #expect(output.contains("privacy-sensitive=\"urlAndDisplay\""))
        #expect(output.contains("protected-link"))
    }
}
