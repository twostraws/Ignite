//
//  TransitionModifier.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `TransitionModifier`.
@Suite("TransitionModifier Tests")
@MainActor
class TransitionModifierTests: IgniteTestSuite {
    @Test("Hover transition adds hover class and 3D transform style")
    func hoverTransitionAddsHoverClassAndStyle() async throws {
        let transition = Transition.scale()
        let element = Text("Hello").transition(transition, on: .hover)
        let output = element.markupString()

        let hoverID = firstCapturedGroup(
            in: output,
            pattern: #"class="[^"]*animation-([A-Za-z0-9]{5})-hover[^"]*""#
        )

        #expect(hoverID != nil)
        #expect(output.contains(#"style="transform-style: preserve-3d""#))
        #expect(output.contains("Hello"))
        #expect(!output.contains(#"onclick="igniteToggleClickAnimation(this)""#))
        #expect(!output.contains(#"class="click-"#))
    }

    @Test("Click transition adds click handler and paired class names")
    func clickTransitionAddsClickHandler() async throws {
        let transition = Transition.scale()
        let element = Text("Hello").transition(transition, on: .click)
        let output = element.markupString()

        let animationID = firstCapturedGroup(
            in: output,
            pattern: #"class="[^"]*animation-([A-Za-z0-9]{5})[^"]*""#
        )
        let clickID = firstCapturedGroup(
            in: output,
            pattern: #"class="[^"]*click-([A-Za-z0-9]{5})[^"]*""#
        )

        #expect(animationID != nil)
        #expect(clickID != nil)
        #expect(output.contains(#"onclick="igniteToggleClickAnimation(this)""#))
        #expect(output.contains("Hello"))

        if let animationID, let clickID {
            #expect(animationID == clickID)
        }
    }

    @Test("Appear transition adds animation class without click or hover scaffolding")
    func appearTransitionAddsAppearClassOnly() async throws {
        let transition = Transition.scale()
        let element = Text("Hello").transition(transition, on: .appear)
        let output = element.markupString()

        let appearID = firstCapturedGroup(
            in: output,
            pattern: #"class="[^"]*animation-([A-Za-z0-9]{5})[^"]*""#
        )

        #expect(appearID != nil)
        #expect(output.contains("Hello"))
        #expect(!output.contains("-hover"))
        #expect(!output.contains(#"onclick="igniteToggleClickAnimation(this)""#))
        #expect(!output.contains(#"class="click-"#))
    }

    private func firstCapturedGroup(in source: String, pattern: String, group: Int = 1) -> String? {
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return nil
        }

        let sourceRange = NSRange(source.startIndex..<source.endIndex, in: source)

        guard let match = regex.firstMatch(in: source, options: [], range: sourceRange),
              let captureRange = Range(match.range(at: group), in: source) else {
            return nil
        }

        return String(source[captureRange])
    }
}
