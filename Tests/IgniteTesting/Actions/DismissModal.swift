//
//  DismissModal.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `DismissModal` action.
@Suite("DismissModal Tests")
@MainActor
class DismissModalTests: IgniteTestSuite {
    @Test("compile() injects the provided modal ID and hide flow")
    func compilesWithProvidedID() async throws {
        let action = DismissModal(id: "modal-42")
        let output = action.compile()

        #expect(output.contains("document.getElementById('modal-42')"))
        #expect(output.contains("bootstrap.Modal.getInstance(modal)"))
        #expect(output.contains("if (modalInstance) { modalInstance.hide(); }"))
    }
}
