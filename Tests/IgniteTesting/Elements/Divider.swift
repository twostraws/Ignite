//
//  Divider.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Divider` element.
@Suite("Divider Tests")
@MainActor
class DividerTests: IgniteTestSuite {
    @Test("A single divider")
    func singleDivider() async throws {
        let element = Divider()
        let output = element.markupString()
        #expect(output == "<hr />")
    }

    @Test("Divider with custom class includes class attribute")
    func customClass() async throws {
        let element = Divider().class("my-divider")
        let output = element.markupString()
        #expect(output.contains("class=\"my-divider\""))
        #expect(output.contains("<hr"))
    }

    @Test("Divider with ID includes id attribute")
    func idAttribute() async throws {
        let element = Divider().id("section-break")
        let output = element.markupString()
        #expect(output.contains("id=\"section-break\""))
    }

    @Test("Divider with style includes style attribute")
    func styleAttribute() async throws {
        let element = Divider().style(.borderColor, "red")
        let output = element.markupString()
        #expect(output.contains("style=\"border-color: red\""))
    }

    @Test("Divider with multiple attributes combines them")
    func multipleAttributes() async throws {
        let element = Divider()
            .id("break")
            .class("thick")
        let output = element.markupString()
        #expect(output.contains("id=\"break\""))
        #expect(output.contains("class=\"thick\""))
    }
}
