//
//  IgniteFooter.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `IgniteFooter` element.
@Suite("IgniteFooter Tests")
@MainActor
class IgniteFooterTests: IgniteTestSuite {
    @Test("Default Ignite Footer")
    func defaultIgniteFooter() async throws {
        let element = IgniteFooter()
        let output = element.render()

        #expect(output == """
        <p class="text-center mt-5">\
        Created in Swift with \
        <a href="https://github.com/twostraws/Ignite">Ignite</a>\
        </p>
        """)
    }
}
