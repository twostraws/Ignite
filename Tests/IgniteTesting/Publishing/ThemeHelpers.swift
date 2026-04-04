//
// ThemeHelpers.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// A theme with custom responsive font sizes for testing.
private struct CustomFontTheme: Theme {
    var colorScheme: ColorScheme = .light
    var h1Size: ResponsiveValues = .init(medium: .rem(2.5))
}

/// A theme with multiple responsive font sizes for testing.
private struct MultiResponsiveTheme: Theme {
    var colorScheme: ColorScheme = .light
    var h1Size: ResponsiveValues = .init(medium: .rem(2.5))
    var h2Size: ResponsiveValues = .init(large: .rem(2))
}

/// Tests for theme helper methods on PublishingContext.
@Suite("Theme Helpers Tests")
class ThemeHelpersTests: IgniteTestSuite {

    // MARK: - responsiveVariables tests

    @Test("Default theme produces no responsive variable media queries")
    func defaultThemeNoResponsiveVariables() throws {
        let queries = publishingContext.responsiveVariables(for: DefaultLightTheme())
        #expect(queries.isEmpty)
    }

    @Test("Custom font theme produces responsive variable media queries")
    func customFontThemeResponsiveVariables() throws {
        let queries = publishingContext.responsiveVariables(for: CustomFontTheme())
        #expect(!queries.isEmpty)
    }

    @Test("Responsive variables contain correct breakpoint width")
    func responsiveVariablesContainBreakpointWidth() throws {
        let queries = publishingContext.responsiveVariables(for: CustomFontTheme())
        let descriptions = queries.map(\.description)

        // Medium breakpoint is 768px
        #expect(descriptions.contains { $0.contains("768px") })
    }

    @Test("Responsive variables contain correct font size variable")
    func responsiveVariablesContainFontVariable() throws {
        let queries = publishingContext.responsiveVariables(for: CustomFontTheme())
        let descriptions = queries.map(\.description)

        #expect(descriptions.contains { $0.contains("--bs-h1-font-size") })
    }

    @Test("Multiple responsive font sizes produce combined media queries")
    func multipleResponsiveFontSizes() throws {
        let queries = publishingContext.responsiveVariables(for: MultiResponsiveTheme())
        let descriptions = queries.map(\.description)

        // Should have entries for medium (h1) and large (h2) breakpoints
        #expect(descriptions.contains { $0.contains("768px") })
        #expect(descriptions.contains { $0.contains("992px") })
    }

    // MARK: - themeStyles tests

    @Test("Default light theme styles include accent color variable")
    func defaultThemeIncludesAccentColor() throws {
        let styles = publishingContext.themeStyles(for: DefaultLightTheme())
        let hasAccent = styles.contains { $0.property == "--bs-primary" }
        #expect(hasAccent)
    }

    @Test("Default light theme styles include body color variable")
    func defaultThemeIncludesBodyColor() throws {
        let styles = publishingContext.themeStyles(for: DefaultLightTheme())
        let hasBodyColor = styles.contains { $0.property == "--bs-body-color" }
        #expect(hasBodyColor)
    }

    @Test("Default light theme styles include background variable")
    func defaultThemeIncludesBackground() throws {
        let styles = publishingContext.themeStyles(for: DefaultLightTheme())
        let hasBackground = styles.contains { $0.property == "--bs-body-bg" }
        #expect(hasBackground)
    }

    @Test("Default light theme styles include link color variable")
    func defaultThemeIncludesLinkColor() throws {
        let styles = publishingContext.themeStyles(for: DefaultLightTheme())
        let hasLinkColor = styles.contains { $0.property == "--bs-link-color" }
        #expect(hasLinkColor)
    }

    @Test("Dark theme produces different body color than light theme")
    func darkThemeDifferentBodyColor() throws {
        let lightStyles = publishingContext.themeStyles(for: DefaultLightTheme())
        let darkStyles = publishingContext.themeStyles(for: DefaultDarkTheme())

        let lightBodyColor = lightStyles.first { $0.property == "--bs-body-color" }?.value
        let darkBodyColor = darkStyles.first { $0.property == "--bs-body-color" }?.value

        #expect(lightBodyColor != nil)
        #expect(darkBodyColor != nil)
        #expect(lightBodyColor != darkBodyColor)
    }

    @Test("Theme styles include syntax highlighter theme variable")
    func themeStylesIncludeSyntaxHighlighter() throws {
        let styles = publishingContext.themeStyles(for: DefaultLightTheme())
        let hasSyntaxTheme = styles.contains { $0.property == "--syntax-highlight-theme" }
        #expect(hasSyntaxTheme)
    }

    // MARK: - rootStyles tests

    @Test("Root styles use :root pseudo-class selector")
    func rootStylesUsePseudoClass() throws {
        let ruleset = publishingContext.rootStyles(for: DefaultLightTheme())
        let output = ruleset.description
        #expect(output.contains(":root"))
    }
}
