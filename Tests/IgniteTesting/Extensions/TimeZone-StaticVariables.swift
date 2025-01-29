//
// TimeZone-StaticVariables.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Testing
import Foundation

@testable import Ignite

@Suite("TimeZone-Constants")
@MainActor
struct Test {

    @Test("gmt equals time zone with identifier GMT") func gmt_equals_expected_value() async throws {
        let sut = TimeZone.gmt

        #expect(sut == TimeZone(identifier: "GMT"))
    }

    @Test("gmt has no offset from GMT")
    func gmt_has_zero_gmt_offset() async throws {
        let sut = TimeZone.gmt

        #expect(sut?.secondsFromGMT() == 0)
    }

}
