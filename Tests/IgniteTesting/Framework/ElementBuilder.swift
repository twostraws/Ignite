//
//  ElementBuilder.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the generic `ElementBuilder` result builder.
@Suite("ElementBuilder Tests")
@MainActor
struct ElementBuilderTests {
    private func buildInts(@ElementBuilder<Int> content: () -> [Int]) -> [Int] {
        content()
    }

    @Test("Single expression produces single-element array")
    func singleExpression() async throws {
        let result = buildInts { 42 }
        #expect(result == [42])
    }

    @Test("Multiple expressions produce ordered array")
    func multipleExpressions() async throws {
        let result = buildInts {
            1
            2
            3
        }
        #expect(result == [1, 2, 3])
    }

    @Test("Optional nil produces empty array")
    func optionalNil() async throws {
        let include = false
        let result = buildInts {
            if include {
                99
            }
        }
        #expect(result == [])
    }

    @Test("Optional non-nil includes element")
    func optionalNonNil() async throws {
        let include = true
        let result = buildInts {
            if include {
                99
            }
        }
        #expect(result == [99])
    }

    @Test("If-else selects correct branch")
    func ifElse() async throws {
        let condition = false
        let result = buildInts {
            if condition {
                1
            } else {
                2
            }
        }
        #expect(result == [2])
    }

    @Test("For loop flattens into array")
    func forLoop() async throws {
        let result = buildInts {
            for i in 1...3 {
                i
            }
        }
        #expect(result == [1, 2, 3])
    }
}
