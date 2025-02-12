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
    @Test("Privacy Sensitive Modifier",
          arguments: [PrivacyEncoding.urlOnly, PrivacyEncoding.urlAndDisplay])
    func privacySensitive(encoding: PrivacyEncoding) async throws {
        let element = Link("Go Home", target: "/").privacySensitive(encoding)
        let output = element.render()

        #expect(output.contains("privacy-sensitive=\"\(encoding.rawValue)\""))
        #expect(output.contains("protected-link"))
    }
}
