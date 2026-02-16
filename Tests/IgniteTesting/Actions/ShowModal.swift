//
//  ShowModal.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `ShowModal` action.
@Suite("ShowModal Tests")
@MainActor
class ShowModalTests: IgniteTestSuite {
    // Note: Individual option tests (.backdrop, .focus, .keyboard, .noBackdrop)
    // are covered by Modal.swift's checkModalPresentationOptions parameterized test.

    @Test("compile() with no options produces empty options block and modal.show()")
    func noOptions() async throws {
        let action = ShowModal(id: "myModal")
        let output = action.compile()

        #expect(output.contains("const options = {"))
        #expect(output.contains("new bootstrap.Modal(document.getElementById('myModal'), options)"))
        #expect(output.contains("modal.show();"))
    }

    @Test("compile() with multiple options joins them in the options block")
    func multipleOptions() async throws {
        let action = ShowModal(id: "m", options: [.focus(true), .keyboard(false)])
        let output = action.compile()

        #expect(output.contains("focus: true"))
        #expect(output.contains("keyboard: false"))
        #expect(output.contains("modal.show();"))
    }
}
