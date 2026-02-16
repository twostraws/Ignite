//
//  TransitionModifier.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

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

        let hoverID = firstHoverAnimationID(in: output)

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

        let animationID = firstAnimationID(in: output)
        let clickID = firstClickID(in: output)

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

        let appearID = firstAnimationID(in: output)

        #expect(appearID != nil)
        #expect(output.contains("Hello"))
        #expect(!output.contains("-hover"))
        #expect(!output.contains(#"onclick="igniteToggleClickAnimation(this)""#))
        #expect(!output.contains(#"class="click-"#))
    }

    private func firstHoverAnimationID(in source: String) -> String? {
        source.firstMatch(of: /class="[^"]*animation-([A-Za-z0-9]{5})-hover[^"]*"/).map { String($0.1) }
    }

    private func firstAnimationID(in source: String) -> String? {
        source.firstMatch(of: /class="[^"]*animation-([A-Za-z0-9]{5})[^"]*"/).map { String($0.1) }
    }

    private func firstClickID(in source: String) -> String? {
        source.firstMatch(of: /class="[^"]*click-([A-Za-z0-9]{5})[^"]*"/).map { String($0.1) }
    }
}
