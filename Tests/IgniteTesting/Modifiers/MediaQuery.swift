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
struct MediaQueryTests {

    typealias MediaQueryTestCase = (query: MediaQuery, output: String)

    @Test("Test breakpoint queries", arguments: [
        (query: MediaQuery.breakpoint(.small),
         output: "min-width: 576px"),
        (query: MediaQuery.breakpoint(.medium),
         output: "min-width: 768px"),
        (query: MediaQuery.breakpoint(.large),
         output: "min-width: 992px"),
        (query: MediaQuery.breakpoint(.xLarge),
         output: "min-width: 1200px"),
        (query: MediaQuery.breakpoint(.xxLarge),
         output: "min-width: 1400px"),
    ])
    func breakpoint_queries_render_correctly(testCase: MediaQueryTestCase) async throws {
        let query = testCase.query
        let output = query.query(with: .light)

        #expect(
            output == testCase.output
        )
    }

    @Test("Test color scheme queries", arguments: [
        (query: MediaQuery.colorScheme(.light),
         output: "prefers-color-scheme: light"),
        (query: MediaQuery.colorScheme(.dark),
         output: "prefers-color-scheme: dark")
    ])
    func color_scheme_queries_render_correctly(testCase: MediaQueryTestCase) async throws {
        let query = testCase.query
        let output = query.query(with: .light)

        #expect(
            output == testCase.output
        )
    }

    @Test("Test contrast queries", arguments: [
        (query: MediaQuery.contrast(.high),
         output: "prefers-contrast: more"),
        (query: MediaQuery.contrast(.low),
         output: "prefers-contrast: less"),
        (query: MediaQuery.contrast(.reduced),
         output: "prefers-contrast: less")
    ])
    func contrast_queries_render_correctly(testCase: MediaQueryTestCase) async throws {
        let query = testCase.query
        let output = query.query(with: .light)

        #expect(
            output == testCase.output
        )
    }

    @Test("Test display mode queries", arguments: [
        (query: MediaQuery.displayMode(.fullscreen),
         output: "display-mode: fullscreen"),
        (query: MediaQuery.displayMode(.browser),
         output: "display-mode: browser"),
        (query: MediaQuery.displayMode(.minimalUI),
         output: "display-mode: minimal-ui"),
        (query: MediaQuery.displayMode(.pip),
         output: "display-mode: picture-in-picture"),
        (query: MediaQuery.displayMode(.standalone),
         output: "display-mode: standalone"),
        (query: MediaQuery.displayMode(.windowControlsOverlay),
         output: "display-mode: window-controls-overlay")
    ])
    func display_mode_queries_render_correctly(testCase: MediaQueryTestCase) async throws {
        let query = testCase.query
        let output = query.query(with: .light)

        #expect(
            output == testCase.output
        )
    }
}
