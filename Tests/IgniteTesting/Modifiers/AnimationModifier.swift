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
    func htmlAnimationModifierBounce() async throws {
        let element = Text {
            Span("This is a Span")
        }.animation(Animation.bounce, on: .hover)

        let output = element.render()

        let pattern = """
            <div class="animation-([a-zA-Z0-9]{4})-transform" style="transform-style: preserve-3d">\
            <div class="animation-([a-zA-Z0-9]{4})-hover"><p><span>This is a Span</span></p></div></div>
            """

        // Create a Swift Regex object
        do {
            let regex = try Regex(pattern)

            // Check if the output matches the pattern
            if let match = output.firstMatch(of: regex) {
                // Use #expect to assert that the output matches the pattern
                #expect(match.output.count > 0, "Output does not match the expected pattern")
            } else {
                Issue.record("Output does not match the expected pattern")
            }
        } catch {
            // Record an issue to fail the test with a descriptive message
            Issue.record("Failed to create regular expression: \(error)")
        }
        // Example result:
        // <div class="animation-H57c-transform" style="transform-style: preserve-3d">
        // <div class="animation-H57c-hover"><p><span>This is a Span</span></p></div></div>
        // The 'H57c' is a random element, that varies at runtime but should be the same for both divs
    }
}
