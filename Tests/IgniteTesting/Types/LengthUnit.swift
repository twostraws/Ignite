//
//  LengthUnit.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `LengthUnit` type.
@Suite("LengthUnit Tests")
@MainActor
struct LengthUnitTests {
    @Test("Pixels length unit", arguments: [10, 25, 152])
    func pixels(pixelAmount: Int) async throws {
        let element = LengthUnit.px(pixelAmount)
        #expect(element.description == "\(pixelAmount)px")
    }

    @Test("rem length unit", arguments: [10, 25, 152])
    func rem(pixelAmount: Double) async throws {
        let element = LengthUnit.rem(pixelAmount)
        #expect(element.description == "\(pixelAmount)rem")
    }

    @Test("em length unit", arguments: [10, 25, 152])
    func em(pixelAmount: Double) async throws {
        let element = LengthUnit.em(pixelAmount)
        #expect(element.description == "\(pixelAmount)em")
    }

    @Test("Percentage length unit", arguments: [10%, 25%, -67%])
    func percentage(percent: Percentage) async throws {
        let element = LengthUnit.percent(percent)
        #expect(element.description == "\(percent.value)%")
    }

    @Test("vw length unit", arguments: [10%, 25%, -67%])
    func vw(percent: Percentage) async throws {
        let element = LengthUnit.vw(percent)
        #expect(element.description == "\(percent.value)vw")
    }

    @Test("vh length unit", arguments: [10%, 25%, -67%])
    func vh(percent: Percentage) async throws {
        let element = LengthUnit.vh(percent)
        #expect(element.description == "\(percent.value)vh")
    }

    @Test("Custom length unit", arguments: ["60vw", "300px", "25%"])
    func custom(unit: String) async throws {
        let element = LengthUnit.custom(unit)
        #expect(element.description == unit)
    }

    @Test("Default value")
    func defaultValue() {
        let element = LengthUnit.default

        #expect(element == .em(.infinity))
        #expect(element.description == "infem")
    }

    @Test("Is default value", arguments: zip(
        [LengthUnit.em(20), .percent(Percentage(.infinity)), .em(.infinity)],
        [false, false, true]))
    func isDefault(unit: LengthUnit, expected: Bool) {
        #expect(unit.isDefault == expected)
    }
}
