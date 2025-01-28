//
//  UnitPoint.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `UnitPoint` type.
@Suite("UnitPoint Tests")
@MainActor
struct UnitPointTests {
    struct UnitPointTestParams: Sendable {
        let start: UnitPoint
        let end: UnitPoint
        let expected: Double
    }

    @Test("Test the top leading unit point.")
    func topLeadingUnitPoint() async throws {
        let element = UnitPoint.topLeading
        #expect(element.justifySelf == "start" && element.alignSelf == "start")
    }

    @Test("Test the top unit point.")
    func topUnitPoint() async throws {
        let element = UnitPoint.top
        #expect(element.justifySelf == "center" && element.alignSelf == "start")
    }

    @Test("Test the top trailing unit point.")
    func topTrailingUnitPoint() async throws {
        let element = UnitPoint.topTrailing
        #expect(element.justifySelf == "end" && element.alignSelf == "start")
    }

    @Test("Test the leading unit point.")
    func leadingUnitPoint() async throws {
        let element = UnitPoint.leading
        #expect(element.justifySelf == "start" && element.alignSelf == "center")
    }

    @Test("Test the center unit point.")
    func centerUnitPoint() async throws {
        let element = UnitPoint.center
        #expect(element.justifySelf == "center" && element.alignSelf == "center")
    }

    @Test("Test the trailing unit point.")
    func trailingUnitPoint() async throws {
        let element = UnitPoint.trailing
        #expect(element.justifySelf == "end" && element.alignSelf == "center")
    }

    @Test("Test the bottom leading unit point.")
    func bottomLeadingUnitPoint() async throws {
        let element = UnitPoint.bottomLeading
        #expect(element.justifySelf == "start" && element.alignSelf == "end")
    }

    @Test("Test the bottom unit point.")
    func bottomUnitPoint() async throws {
        let element = UnitPoint.bottom
        #expect(element.justifySelf == "center" && element.alignSelf == "end")
    }

    @Test("Test the bottom trailing unit point.")
    func bottomTrailingUnitPoint() async throws {
        let element = UnitPoint.bottomTrailing
        #expect(element.justifySelf == "end" && element.alignSelf == "end")
    }

    @Test("Test the degrees calculation.", arguments: [
        UnitPointTestParams(start: UnitPoint.topLeading, end: UnitPoint.bottomTrailing, expected: 135),
        UnitPointTestParams(start: UnitPoint.top, end: UnitPoint.bottom, expected: 180),
        UnitPointTestParams(start: UnitPoint.topTrailing, end: UnitPoint.bottomLeading, expected: 225),
        UnitPointTestParams(start: UnitPoint.topTrailing, end: UnitPoint.topLeading, expected: 270),
        UnitPointTestParams(start: UnitPoint.bottomLeading, end: UnitPoint.topTrailing, expected: 45),
        UnitPointTestParams(start: UnitPoint.center, end: UnitPoint.topLeading, expected: 315),
        UnitPointTestParams(start: UnitPoint.leading, end: UnitPoint.trailing, expected: 90),
        UnitPointTestParams(start: UnitPoint.bottom, end: UnitPoint.top, expected: 0)
    ])
    func degrees(params: UnitPointTestParams) async throws {
        let element = params.start.degrees(to: params.end)
        #expect(element == params.expected)
    }

    @Test("Test the radians calculation.", arguments: [
        UnitPointTestParams(start: UnitPoint.topLeading, end: UnitPoint.bottomTrailing, expected: 2.356194490192345),
        UnitPointTestParams(start: UnitPoint.top, end: UnitPoint.bottom, expected: 3.141592653589793),
        UnitPointTestParams(start: UnitPoint.topTrailing, end: UnitPoint.bottomLeading, expected: 3.9269908169872414),
        UnitPointTestParams(start: UnitPoint.topTrailing, end: UnitPoint.topLeading, expected: 4.71238898038469),
        UnitPointTestParams(start: UnitPoint.bottomLeading, end: UnitPoint.topTrailing, expected: 0.7853981633974483),
        UnitPointTestParams(start: UnitPoint.center, end: UnitPoint.topLeading, expected: 5.497787143782138),
        UnitPointTestParams(start: UnitPoint.leading, end: UnitPoint.trailing, expected: 1.5707963267948966),
        UnitPointTestParams(start: UnitPoint.bottom, end: UnitPoint.top, expected: 0)
    ])
    func radians(params: UnitPointTestParams) async throws {
        let element = params.start.radians(to: params.end)
        #expect(element == params.expected)
    }
}
