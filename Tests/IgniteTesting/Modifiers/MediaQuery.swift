//
// MediaQuery.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Margin` modifier.
@Suite("MediaQuery Tests")
@MainActor
class MediaQueryTests: IgniteTestSuite {
    @Test("Breakpoint queries", arguments: zip(
        BreakpointQuery.allCases,
        ["min-width: 576px", "min-width: 768px", "min-width: 992px", "min-width: 1200px", "min-width: 1400px"]))
    func breakpoint_queries_render_correctly(query: BreakpointQuery, css: String) async throws {
        let output = query.condition
        #expect(output == css)
    }

    @Test("Color scheme queries", arguments: zip(
        ColorSchemeQuery.allCases,
        ["prefers-color-scheme: dark", "prefers-color-scheme: light"]))
    func color_scheme_queries_render_correctly(query: any Query, css: String) async throws {
        let output = query.condition
        #expect(output == css)
    }

    @Test("Contrast queries", arguments: zip(
        ContrastQuery.allCases,
        ["prefers-contrast: no-preference",
         "prefers-contrast: more",
         "prefers-contrast: less"]))
    func contrast_queries_render_correctly(query: any Query, css: String) async throws {
        let output = query.condition
        #expect(output == css)
    }

    @Test("Display mode queries", arguments: zip(
        DisplayModeQuery.allCases,
        ["display-mode: browser",
         "display-mode: fullscreen",
         "display-mode: minimal-ui",
         "display-mode: picture-in-picture",
         "display-mode: standalone",
         "display-mode: window-controls-overlay"]))
    func display_mode_queries_render_correctly(query: any Query, css: String) async throws {
        let output = query.condition
        #expect(output == css)
    }

    @Test("Orientation queries", arguments: zip(
        OrientationQuery.allCases,
        ["orientation: portrait", "orientation: landscape"]))
    func orientation_queries_render_correctly(query: any Query, css: String) async throws {
        let output = query.condition
        #expect(output == css)
    }

    @Test("Transparency queries", arguments: zip(
        TransparencyQuery.allCases,
        ["prefers-reduced-transparency: reduce", "prefers-reduced-transparency: no-preference"]))
    func transparency_queries_render_correctly(query: any Query, css: String) async throws {
        let output = query.condition
        #expect(output == css)
    }

    @Test("Reduced motion queries", arguments: zip(
        MotionQuery.allCases,
        ["prefers-reduced-motion: reduce", "prefers-reduced-motion: no-preference"]))
    func reduced_motion_queries_render_correctly(query: any Query, css: String) async throws {
        let output = query.condition
        #expect(output == css)
    }

    @Test("Theme queries", arguments: zip(
        [ThemeQuery(DefaultDarkTheme.self), ThemeQuery(DefaultLightTheme.self), ThemeQuery(AutoTheme.self)],
        ["data-bs-theme^=\"dark\"", "data-bs-theme^=\"light\"", "data-bs-theme^=\"auto\""]))
    func theme_queries_render_correctly(query: ThemeQuery, css: String) async throws {
        let output = query.condition
        #expect(output == css)
    }
}
