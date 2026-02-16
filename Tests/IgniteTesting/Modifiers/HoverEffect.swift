//
//  HoverEffect.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `HoverEffect` modifier.
@Suite("HoverEffect Tests")
@MainActor
class HoverEffectTests: IgniteTestSuite {
    @Test("HTML hoverEffect adds mouse handlers and converted JavaScript style assignments")
    func htmlHoverEffectCompilesExpectedJavaScript() async throws {
        let element = Text("Hover me")
            .hoverEffect { effect in
                effect
                    .style(.backgroundColor, "red")
                    .style(.fontWeight, "700")
            }

        let output = element.markupString()

        #expect(output.contains("onmouseover=\""))
        #expect(output.contains("onmouseout=\""))
        #expect(output.contains("this.unhoveredStyle = this.style.cssText;"))
        #expect(output.contains("this.style.backgroundColor = 'red'"))
        #expect(output.contains("this.style.fontWeight = '700'"))
        #expect(output.contains("this.style.cssText = this.unhoveredStyle;"))
    }

    @Test("Inline hoverEffect applies generated handlers to inline elements")
    func inlineHoverEffectCompilesExpectedJavaScript() async throws {
        let element = Emphasis("Hover me")
            .hoverEffect { effect in
                effect.style(.letterSpacing, "2px")
            }

        let output = element.markupString()

        #expect(output.hasPrefix("<em "))
        #expect(output.contains("onmouseover=\""))
        #expect(output.contains("onmouseout=\""))
        #expect(output.contains("this.style.letterSpacing = '2px'"))
        #expect(output.contains("this.style.cssText = this.unhoveredStyle;"))
    }

    @Test("Hover effect preserves style insertion order when compiling JavaScript")
    func hoverEffectPreservesStyleOrder() async throws {
        let element = Text("Hover me")
            .hoverEffect { effect in
                effect
                    .style(.color, "white")
                    .style(.backgroundColor, "black")
            }

        let output = element.markupString()

        let colorIndex = output.range(of: "this.style.color = 'white'")?.lowerBound
        let backgroundIndex = output.range(of: "this.style.backgroundColor = 'black'")?.lowerBound

        #expect(colorIndex != nil)
        #expect(backgroundIndex != nil)

        if let colorIndex, let backgroundIndex {
            #expect(colorIndex < backgroundIndex)
        }
    }
}
