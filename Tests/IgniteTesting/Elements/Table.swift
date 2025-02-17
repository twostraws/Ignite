//
//  Table.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

@Suite("Table Tests")
@MainActor
class TableTests: IgniteTestSuite {
    @Test func simpleTable() async throws {
        let element = Table { }
        let output = element.render()
        #expect(output == "<table class=\"table\"><tbody></tbody></table>")
    }
}
