//
//  Input.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Input` element.
@Suite("Input Tests")
class InputTests: IgniteTestSuite {
    @Test("Basic input renders self-closing tag", .publishingContext())
    func basicInputRendersSelfClosingTag() async throws {
        let element = Input()
        let output = element.markupString()
        #expect(output == "<input />")
    }

    @Test("Input with id attribute", .publishingContext())
    func inputWithIdAttribute() async throws {
        let element = Input().id("my-input")
        let output = element.markupString()
        #expect(output.contains("id=\"my-input\""))
        #expect(output.hasPrefix("<input"))
        #expect(output.hasSuffix("/>"))
    }

    @Test("Input with class attribute", .publishingContext())
    func inputWithClassAttribute() async throws {
        let element = Input().class("form-control")
        let output = element.markupString()
        #expect(output.contains("class=\"form-control\""))
    }
}
