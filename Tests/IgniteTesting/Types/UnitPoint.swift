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
    static let unitPoints: [UnitPoint] = [
        .topLeading, .top, .topTrailing,
        .leading, .center, .trailing,
        .bottomLeading, .bottom, .bottomTrailing
    ]

    static let alignmentValues: [(justifySelf: String, alignSelf: String)] = [
       ("start", "start"),   // topLeading
       ("center", "start"),  // top
       ("end", "start"),     // topTrailing
       ("start", "center"),  // leading
       ("center", "center"), // center
       ("end", "center"),    // trailing
       ("start", "end"),     // bottomLeading
       ("center", "end"),    // bottom
       ("end", "end")        // bottomTrailing
    ]

    static let pointPairs: [(start: UnitPoint, end: UnitPoint)] = [
       (.topLeading, .bottomTrailing),
       (.top, .bottom),
       (.topTrailing, .bottomLeading),
       (.topTrailing, .topLeading),
       (.bottomLeading, .topTrailing),
       (.center, .topLeading),
       (.leading, .trailing),
       (.bottom, .top)
    ]

    static let degreeValues: [Double] = [
       135,  // topLeading to bottomTrailing
       180,  // top to bottom
       225,  // topTrailing to bottomLeading
       270,  // topTrailing to topLeading
       45,   // bottomLeading to topTrailing
       315,  // center to topLeading
       90,   // leading to trailing
       0     // bottom to top
    ]

    static let radianValues: [Double] = [
       2.356194490192345,   // topLeading to bottomTrailing
       3.141592653589793,   // top to bottom
       3.9269908169872414,  // topTrailing to bottomLeading
       4.71238898038469,    // topTrailing to topLeading
       0.7853981633974483,  // bottomLeading to topTrailing
       5.497787143782138,   // center to topLeading
       1.5707963267948966,  // leading to trailing
       0                    // bottom to top
    ]

    @Test("Degrees calculation", arguments: await zip(pointPairs, degreeValues))
    func degrees(_ points: (start: UnitPoint, end: UnitPoint), expected: Double) async throws {
       let element = points.start.degrees(to: points.end)
       #expect(element == expected)
    }

    @Test("Radians calculation", arguments: await zip(pointPairs, radianValues))
    func radians(_ points: (start: UnitPoint, end: UnitPoint), expected: Double) async throws {
       let element = points.start.radians(to: points.end)
       #expect(element == expected)
    }
}
