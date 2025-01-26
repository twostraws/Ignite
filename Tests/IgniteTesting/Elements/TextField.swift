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

    @Test("TextField with Placeholder and Label")
    func textFieldWithPlaceholderAndLabel() async throws {
        let element = TextField("Paul", placeholder: "Enter your name here")
        let output = element.render()

        #expect(output == """
        <input placeholder="Enter your name here" type="text" class="form-control" />
        """)
    }

    @Test("TextField with standard text input")
    func textFieldWithStandardTextInput() async throws {
        let element = TextField("Paul", placeholder: "Enter your name here")
        let output = element.render()

        #expect(output == """
        <input placeholder="Enter your name here" type="text" class="form-control" />
        """)
    }

    @Test("TextField with email address input")
    func textFieldWithEmailAddressInput() async throws {
        let element = TextField("Paul", placeholder: "Enter your name here").type(.email)
        let output = element.render()

        #expect(output == """
        <input placeholder="Enter your name here" type="email" class="form-control" />
        """)
    }

    @Test("TextField with password input")
    func textFieldWithPasswordInput() async throws {
        let element = TextField("Paul", placeholder: "Enter your name here").type(.password)
        let output = element.render()

        #expect(output == """
        <input placeholder="Enter your name here" type="password" class="form-control" />
        """)
    }

    @Test("TextField with phone input")
    func textFieldWithPhoneInput() async throws {
        let element = TextField("Paul", placeholder: "Enter your name here").type(.phone)
        let output = element.render()

        #expect(output == """
        <input placeholder="Enter your name here" type="phone" class="form-control" />
        """)
    }

    @Test("TextField with url input")
    func textFieldWithUrlInput() async throws {
        let element = TextField("Paul", placeholder: "Enter your name here").type(.url)
        let output = element.render()

        #expect(output == """
        <input placeholder="Enter your name here" type="url" class="form-control" />
        """)
    }

    @Test("TextField with search input")
    func textFieldWithSearchInput() async throws {
        let element = TextField("Paul", placeholder: "Enter your name here").type(.search)
        let output = element.render()

        #expect(output == """
        <input placeholder="Enter your name here" type="search" class="form-control" />
        """)
    }

    @Test("TextField with number input")
    func textFieldWithNumberInput() async throws {
        let element = TextField("Paul", placeholder: "Enter your name here").type(.number)
        let output = element.render()

        #expect(output == """
        <input placeholder="Enter your name here" type="number" class="form-control" />
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
}
