//
//  ResponsiveValues.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `ResponsiveValues` type.
@Suite("ResponsiveValues Tests")
@MainActor
struct ResponsiveValuesTests {
    @Test("Single xSmall value cascades to all breakpoints")
    func singleValueCascadesToAllBreakpoints() async throws {
        let responsive = ResponsiveValues<Int>(10)
        let values = responsive.values
        #expect(values.count == 6)
        #expect(values[Breakpoint.xSmall] == 10)
        #expect(values[Breakpoint.xxLarge] == 10)
    }

    @Test("Non-cascaded values only include specified breakpoints")
    func nonCascadedValuesOnlyIncludeSpecified() async throws {
        let responsive = ResponsiveValues<Int>(10, medium: 20)
        let values = responsive.values(cascaded: false)
        #expect(values.count == 2)
        #expect(values[Breakpoint.xSmall] == 10)
        #expect(values[Breakpoint.medium] == 20)
    }

    @Test("Cascading fills gaps from smaller breakpoints")
    func cascadingFillsGaps() async throws {
        let responsive = ResponsiveValues<Int>(10, large: 30)
        let values = responsive.values
        #expect(values[Breakpoint.xSmall] == 10)
        #expect(values[Breakpoint.small] == 10)
        #expect(values[Breakpoint.medium] == 10)
        #expect(values[Breakpoint.large] == 30)
        #expect(values[Breakpoint.xLarge] == 30)
        #expect(values[Breakpoint.xxLarge] == 30)
    }

    @Test("No values produces empty dictionary")
    func noValuesProducesEmptyDictionary() async throws {
        let responsive = ResponsiveValues<Int>()
        let values = responsive.values
        #expect(values.isEmpty)
    }

    @Test("Middle-only value does not cascade backwards")
    func middleOnlyValueDoesNotCascadeBackwards() async throws {
        let responsive = ResponsiveValues<Int>(medium: 20)
        let values = responsive.values
        #expect(values[Breakpoint.xSmall] == nil)
        #expect(values[Breakpoint.small] == nil)
        #expect(values[Breakpoint.medium] == 20)
        #expect(values[Breakpoint.large] == 20)
    }

    @Test("All breakpoints specified individually")
    func allBreakpointsSpecified() async throws {
        let responsive = ResponsiveValues<Int>(1, small: 2, medium: 3, large: 4, xLarge: 5, xxLarge: 6)
        let values = responsive.values
        #expect(values.count == 6)
        #expect(values[Breakpoint.xSmall] == 1)
        #expect(values[Breakpoint.small] == 2)
        #expect(values[Breakpoint.medium] == 3)
        #expect(values[Breakpoint.large] == 4)
        #expect(values[Breakpoint.xLarge] == 5)
        #expect(values[Breakpoint.xxLarge] == 6)
    }

    @Test("Equatable conformance")
    func equatableConformance() async throws {
        let a = ResponsiveValues<Int>(10, medium: 20)
        let b = ResponsiveValues<Int>(10, medium: 20)
        let c = ResponsiveValues<Int>(10, medium: 30)
        #expect(a == b)
        #expect(a != c)
    }

    @Test("Hashable conformance")
    func hashableConformance() async throws {
        let a = ResponsiveValues<Int>(10, medium: 20)
        let b = ResponsiveValues<Int>(10, medium: 20)
        let set: Set<ResponsiveValues<Int>> = [a, b]
        #expect(set.count == 1)
    }
}
