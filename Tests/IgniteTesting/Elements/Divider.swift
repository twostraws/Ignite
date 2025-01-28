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
class DividerTests: UITestSuite {
    @Test("Test a single divider")
    func singleDivider() async throws {
        let element = Divider()
        let output = element.render()

        #expect(output == "<hr />")
    }
}
