//
//  TextField.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `TextField` element.
@Suite("TextField Tests")
@MainActor
class TextFieldTests: IgniteTestSuite {
    @Test("TextField with Text Type", arguments: TextField.TextType.allCases)
    func textFieldWithInputTextType(textType: TextField.TextType) async throws {
        let element = TextField("Paul", prompt: "Enter your name here")
            .type(textType)
            .id("field")
        let output = element.render()

        #expect(output == """
        <div class="form-floating">\
        <input id="field" placeholder="Enter your name here" type="\(textType.rawValue)" class="form-control" />\
        <label for="field">Paul</label>\
        </div>
        """)
    }

    @Test("TextField is required")
    func textFieldIsRequired() async throws {
        let element = TextField("Paul", prompt: "Enter your name here")
            .required()
            .id("field")
        let output = element.render()

        #expect(output == """
        <div class="form-floating">\
        <input id="field" type="text" placeholder="Enter your name here" required class="form-control" />\
        <label for="field">Paul</label>\
        </div>
        """)
    }

    @Test("TextField is disabled")
    func textFieldIsDisabled() async throws {
        let element = TextField("Paul", prompt: "Enter your name here")
            .disabled()
            .id("field")
        let output = element.render()

        #expect(output == """
        <div class="form-floating">\
        <input id="field" type="text" placeholder="Enter your name here" disabled class="form-control" />\
        <label for="field">Paul</label>\
        </div>
        """)
    }

    @Test("TextField is read only")
    func textFieldIsReadOnly() async throws {
        let element = TextField("Paul")
            .readOnly("Read only")
            .id("field")
        let output = element.render()

        #expect(output == """
        <div class="form-floating">\
        <input id="field" type="text" readonly value="Read only" class="form-control" />\
        <label for="field">Paul</label>\
        </div>
        """)
    }
}
