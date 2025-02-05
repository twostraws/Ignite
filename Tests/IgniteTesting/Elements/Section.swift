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

struct SectionTests {
    @Test("init With Content Test")
    func initWithContent() async throws {
        let element = Section {
            Span("Hello, World!")
            Span("Goodbye, World!")
        }
        let output = element.render()

        #expect(output == "<div><span>Hello, World!</span><span>Goodbye, World!</span></div>")
    }

}
