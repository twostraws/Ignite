//
//  AnimationModifier.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `AnimationModifier` modifier.
@Suite("AnimationModifier Tests")
@MainActor
struct AnimationModifierTests {
    init() throws {
        try PublishingContext.initialize(for: TestSite(), from: #filePath)
    }

    @Test("HMTL Animation should bounce")
    func htmlAnimationModifier() async throws {
        let element = Text {
            Span("This is a Span")
        }.animation(Animation.bounce, on: .hover)

        let output = element.render()

        let pattern = """
            <div class="animation-([a-zA-Z0-9]{4})-transform" style="transform-style: preserve-3d">\
            <div class="animation-\\1-hover">\
            <p><span>This is a Span</span></p>\
            </div></div>
            """

        // Create a regular expression object with proper error handling
        do {
            let regex = try NSRegularExpression(pattern: pattern)

            // Check if the output matches the pattern
            let range = NSRange(location: 0, length: output.utf16.count)
            let matches = regex.matches(in: output, options: [], range: range)

            // Use #expect to assert that the output matches the pattern
            #expect(!matches.isEmpty, "Output does not match the expected pattern")
        } catch {
            // Record an issue to fail the test with a descriptive
            Issue.record("Failed to create regular expression: \(error)")
        }
        // Example result:
        // <div class="animation-H57c-transform" style="transform-style: preserve-3d">
        // <div class="animation-H57c-hover"><p><span>This is a Span</span></p></div></div>
        // The 'H57c' is a random element, that varies at runtime but should be the same for both divs
    }
}
