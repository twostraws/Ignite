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
struct TextFieldTests {
    @Test("TextField With Placeholder")
    func textFieldWithPlaceholder() async throws {
        let element = TextField(placeholder: "Enter your name here")
        let output = element.render()

        #expect(output == """
        <input placeholder="Enter your name here" type="text" class="form-control" />
        """)
    }

    @Test("TextField with Text Type", arguments: TextField.TextType.allCases)
    func textFieldWithInputTextType(textType: TextField.TextType) async throws {
        let element = TextField("Paul", placeholder: "Enter your name here").type(textType)
        let output = element.render()

        #expect(output == """
        <input placeholder="Enter your name here" type="\(textType.rawValue)" class="form-control" />
        """)
    }

    @Test("TextField is required")
    func textFieldIsRequired() async throws {
        let element = TextField("Paul", placeholder: "Enter your name here").required()
        let output = element.render()

        #expect(output == """
        <input placeholder="Enter your name here" required type="text" class="form-control" />
        """)
    }

    @Test("TextField is disabled")
    func textFieldIsDisabled() async throws {
        let element = TextField("Paul", placeholder: "Enter your name here").disabled()
        let output = element.render()

        #expect(output == """
        <input disabled placeholder="Enter your name here" type="text" class="form-control" />
        """)
    }

    @Test("TextField is read only")
    func textFieldIsReadOnly() async throws {
        let element = TextField("Paul", placeholder: "Enter your name here").readOnly()
        let output = element.render()

        #expect(output == """
        <input placeholder="Enter your name here" readonly type="text" class="form-control" />
        """)
    }

    @Test("TextField attributes are sorted")
    func textFieldAttributesAreSorted() async throws {
        let textField = TextField(placeholder: nil)
            .disabled()
            .readOnly()
            .required()
        let output = textField.render()

        #expect(output == #"<input disabled readonly required type="text" class="form-control" />"#)
    }
}
