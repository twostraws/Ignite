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
struct IgniteFooterTests {
    @Test("Default Ignite Footer")
    func defaultIgniteFooter() async throws {
        let element = IgniteFooter()
        let output = element.render()

        #expect(output == """
        <p class="mt-5 text-center">Created in Swift with \
        <a href="https://github.com/twostraws/Ignite" \
        class="link-underline \
        link-underline-opacity-100 \
        link-underline-opacity-100-hover">Ignite\
        </a>\
        </p>
        """)
    }
}
