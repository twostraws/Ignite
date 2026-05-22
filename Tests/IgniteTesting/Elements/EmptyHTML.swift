//
//  EmptyHTML.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `EmptyHTML` element.
@Suite("EmptyHTML Tests")
class EmptyHTMLTests: IgniteTestSuite {
    @Test("Renders empty string", .publishingContext())
    func rendersEmptyString() async throws {
        let element = EmptyHTML()
        let output = element.markupString()
        #expect(output == "")
    }

    @Test("Markup is empty", .publishingContext())
    func markupIsEmpty() async throws {
        let element = EmptyHTML()
        let markup = element.markup()
        #expect(markup.isEmpty)
    }

    @Test("Is primitive", .publishingContext())
    func isPrimitive() async throws {
        let element = EmptyHTML()
        #expect(element.isPrimitive == true)
    }
}
