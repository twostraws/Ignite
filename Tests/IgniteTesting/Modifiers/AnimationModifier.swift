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
class AnimationModifierTests: IgniteTestSuite {
    @Test("HMTL Animation should bounce")
    func htmlAnimationModifierBounce() async throws {
        let element = Text {
            Span("This is a Span")
        }.animation(Animation.bounce, on: .hover)

        let output = element.render()

        // Example output:
        // <div class="animation-H57c1-hover" style="transform-style: preserve-3d">
        // <div class="animation-H57c1-hover"><p><span>This is a Span</span></p></div></div>
        // Where 'H57c1' is the stable ID of the animation, used to generate the CSS class name
        let pattern = #"""
        <div class="animation-(?<code>[a-zA-Z0-9]{5})-hover" style="transform-style: preserve-3d">\
        <p><span>This is a Span</span></p>\
        </div>
        """#
        .replacingOccurrences(of: "\n", with: "") // Remove line breaks from the pattern

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
    }
}
