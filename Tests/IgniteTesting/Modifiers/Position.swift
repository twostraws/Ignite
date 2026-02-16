//
//  Position.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `Position` modifier.
@Suite("Position Tests")
@MainActor
class PositionTests: IgniteTestSuite {
    @Test("fixedTop applies fixed-top class")
    func fixedTop() async throws {
        let element = Text("Positioned").position(.fixedTop)
        #expect(element.markupString().contains(#"class="fixed-top"#))
    }

    @Test("fixedBottom applies fixed-bottom class")
    func fixedBottom() async throws {
        let element = Text("Positioned").position(.fixedBottom)
        #expect(element.markupString().contains(#"class="fixed-bottom"#))
    }

    @Test("stickyTop applies sticky-top class")
    func stickyTop() async throws {
        let element = Text("Positioned").position(.stickyTop)
        #expect(element.markupString().contains(#"class="sticky-top"#))
    }

    @Test("stickyBottom applies sticky-bottom class")
    func stickyBottom() async throws {
        let element = Text("Positioned").position(.stickyBottom)
        #expect(element.markupString().contains(#"class="sticky-bottom"#))
    }

    @Test("Position raw values match Bootstrap CSS classes")
    func rawValues() async throws {
        #expect(Position.fixedTop.rawValue == "fixed-top")
        #expect(Position.fixedBottom.rawValue == "fixed-bottom")
        #expect(Position.stickyTop.rawValue == "sticky-top")
        #expect(Position.stickyBottom.rawValue == "sticky-bottom")
        #expect(Position.default.rawValue == "")
    }
}
