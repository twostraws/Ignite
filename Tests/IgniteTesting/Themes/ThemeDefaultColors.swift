//
// ThemeDefaultColors.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the default `Theme` colors that rely on `colorScheme` to pick
/// a light- or dark-mode value. Regression coverage for #854, where the
/// default `secondary` and `tertiary` colors were rendered as white because
/// the call sites passed `opacity: 0.75`/`0.5` (a `Double`) instead of
/// `75%`/`50%` (a `Percentage`), causing Swift to pick the 0-1 RGB `Double`
/// initializer and scale the integer RGB components by 255.
@Suite("Default Theme Colors")
@MainActor
struct ThemeDefaultColorsTests {
    @Test("Default light theme secondary color stays within valid RGB range")
    func lightSecondaryStaysInRGBRange() {
        let color = DefaultLightTheme().secondary
        #expect(color.red == 33)
        #expect(color.green == 37)
        #expect(color.blue == 41)
        #expect(color.opacity == 75)
    }

    @Test("Default dark theme secondary color stays within valid RGB range")
    func darkSecondaryStaysInRGBRange() {
        let color = DefaultDarkTheme().secondary
        #expect(color.red == 222)
        #expect(color.green == 226)
        #expect(color.blue == 230)
        #expect(color.opacity == 75)
    }

    @Test("Default light theme tertiary color stays within valid RGB range")
    func lightTertiaryStaysInRGBRange() {
        let color = DefaultLightTheme().tertiary
        #expect(color.red == 33)
        #expect(color.green == 37)
        #expect(color.blue == 41)
        #expect(color.opacity == 50)
    }

    @Test("Default dark theme tertiary color stays within valid RGB range")
    func darkTertiaryStaysInRGBRange() {
        let color = DefaultDarkTheme().tertiary
        #expect(color.red == 222)
        #expect(color.green == 226)
        #expect(color.blue == 230)
        #expect(color.opacity == 50)
    }
}
