//
//  ColorWeight.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `ColorWeight` type.
@Suite("ColorWeight Tests")
@MainActor
struct ColorWeightTests {
    @Test("Raw values are in hundreds from 100 to 900")
    func rawValues() async throws {
        #expect(ColorWeight.lightest.rawValue == 100)
        #expect(ColorWeight.lighter.rawValue == 200)
        #expect(ColorWeight.light.rawValue == 300)
        #expect(ColorWeight.semiLight.rawValue == 400)
        #expect(ColorWeight.regular.rawValue == 500)
        #expect(ColorWeight.semiDark.rawValue == 600)
        #expect(ColorWeight.dark.rawValue == 700)
        #expect(ColorWeight.darker.rawValue == 800)
        #expect(ColorWeight.darkest.rawValue == 900)
    }

    @Test("Mix percentages are symmetric around regular")
    func mixPercentages() async throws {
        #expect(ColorWeight.lightest.mixPercentage == 80)
        #expect(ColorWeight.lighter.mixPercentage == 60)
        #expect(ColorWeight.light.mixPercentage == 40)
        #expect(ColorWeight.semiLight.mixPercentage == 20)
        #expect(ColorWeight.regular.mixPercentage == 0)
        #expect(ColorWeight.semiDark.mixPercentage == 20)
        #expect(ColorWeight.dark.mixPercentage == 40)
        #expect(ColorWeight.darker.mixPercentage == 60)
        #expect(ColorWeight.darkest.mixPercentage == 80)
    }

    @Test("Lighter weights mix with white")
    func lighterWeightsMixWithWhite() async throws {
        #expect(ColorWeight.lightest.mixWithWhite == true)
        #expect(ColorWeight.lighter.mixWithWhite == true)
        #expect(ColorWeight.light.mixWithWhite == true)
        #expect(ColorWeight.semiLight.mixWithWhite == true)
    }

    @Test("Regular and darker weights do not mix with white")
    func darkerWeightsDoNotMixWithWhite() async throws {
        #expect(ColorWeight.regular.mixWithWhite == false)
        #expect(ColorWeight.semiDark.mixWithWhite == false)
        #expect(ColorWeight.dark.mixWithWhite == false)
        #expect(ColorWeight.darker.mixWithWhite == false)
        #expect(ColorWeight.darkest.mixWithWhite == false)
    }
}
