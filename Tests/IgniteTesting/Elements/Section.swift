//
//  Section.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Section` element.
@Suite("Section Tests")
@MainActor
class SectionTests: IgniteTestSuite {
    @Test("Section")
    func section() async throws {
        let element = Section {
            Span("Hello, World!")
            Span("Goodbye, World!")
        }

        let output = element.render()
        #expect(output == "<div><span>Hello, World!</span><span>Goodbye, World!</span></div>")
    }

    @Test("Section with Header")
    func sectionWithHeader() async throws {
        let element = Section("Greetings") {
            Span("Hello, World!")
            Span("Goodbye, World!")
        }
        .headerProminence(.title3)

        let output = element.render()

        #expect(output == """
        <section>\
        <h3>Greetings</h3>\
        <span>Hello, World!</span>\
        <span>Goodbye, World!</span>\
        </section>
        """)
    }
}
