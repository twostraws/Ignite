//
// ThemeIdentity.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Custom themes used for testing identity properties.
private struct SunshineTheme: Theme {
    var colorScheme: ColorScheme = .light
}

private struct MidnightTheme: Theme {
    var colorScheme: ColorScheme = .dark
}

private struct OceanBlueTheme: Theme {
    var colorScheme: ColorScheme = .light
}

/// Tests for Theme identity properties: cssID, idPrefix, and name.
@Suite("Theme Identity Tests")
@MainActor
struct ThemeIdentityTests {

    // MARK: - cssID tests

    @Test("Custom light theme appends '-light' suffix to cssID")
    func customLightThemeCSSID() {
        #expect(SunshineTheme().cssID == "sunshine-light")
    }

    @Test("Custom dark theme appends '-dark' suffix to cssID")
    func customDarkThemeCSSID() {
        #expect(MidnightTheme().cssID == "midnight-dark")
    }

    @Test("Multi-word custom theme uses kebab-cased cssID")
    func multiWordThemeCSSID() {
        #expect(OceanBlueTheme().cssID == "ocean-blue-light")
    }

    // MARK: - idPrefix tests

    @Test("Custom theme idPrefix is kebab-cased and lowercased")
    func customThemeIDPrefix() {
        #expect(SunshineTheme.idPrefix == "sunshine")
        #expect(OceanBlueTheme.idPrefix == "ocean-blue")
    }

    // MARK: - name tests

    @Test("DefaultLightTheme name is derived from base name")
    func defaultLightThemeName() {
        #expect(DefaultLightTheme().name == "light")
    }

    @Test("DefaultDarkTheme name is derived from base name")
    func defaultDarkThemeName() {
        #expect(DefaultDarkTheme().name == "dark")
    }

    @Test("Custom theme name strips 'Theme' suffix")
    func customThemeNameStripsTheme() {
        #expect(SunshineTheme().name == "Sunshine")
    }

    @Test("Multi-word custom theme name is title-cased")
    func multiWordThemeName() {
        #expect(OceanBlueTheme().name == "Ocean Blue")
    }

    // MARK: - Default property tests

    @Test("Custom theme inherits default accent color")
    func customThemeDefaultAccent() {
        let custom = SunshineTheme()
        let defaultTheme = DefaultLightTheme()
        #expect(custom.accent == defaultTheme.accent)
    }

    @Test("Light and dark themes provide different background colors")
    func lightAndDarkBackgroundsDiffer() {
        let light = DefaultLightTheme()
        let dark = DefaultDarkTheme()
        #expect(light.background != dark.background)
    }
}
