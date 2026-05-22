//
//  IgnorePageGutters.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `IgnorePageGutters` modifier.
@Suite("IgnorePageGutters Tests")
class IgnorePageGuttersTests: IgniteTestSuite {
    @Test("Default (true) adds viewport width and calc margin", .publishingContext())
    func defaultTrue() async throws {
        let element = Text("Full width")
            .ignorePageGutters()

        let output = element.markupString()

        #expect(output.contains("width: 100vw"))
        #expect(output.contains("margin-inline: calc(50% - 50vw)"))
    }

    @Test("Explicit true adds viewport width and calc margin", .publishingContext())
    func explicitTrue() async throws {
        let element = Text("Full width")
            .ignorePageGutters(true)

        let output = element.markupString()

        #expect(output.contains("width: 100vw"))
        #expect(output.contains("margin-inline: calc(50% - 50vw)"))
    }

    @Test("False adds container class instead of viewport styles", .publishingContext())
    func falseAddsContainerClass() async throws {
        let element = Text("Contained")
            .ignorePageGutters(false)

        let output = element.markupString()

        #expect(output.contains(#"class="container"#))
        #expect(!output.contains("100vw"))
    }
}
