//
//  HoverModifier.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `HoverModifier` modifier.
@Suite("HoverModifier Tests")
@MainActor
class HoverModifierTests: IgniteTestSuite {
    @Test("onHover adds both onmouseover and onmouseout attributes")
    func hoverAddsMouseEvents() async throws {
        let element = Text("Hover me")
            .onHover { isHovering in
                if isHovering {
                    ShowAlert(message: "entered")
                } else {
                    ShowAlert(message: "left")
                }
            }

        let output = element.markupString()

        #expect(output.contains("onmouseover="))
        #expect(output.contains("onmouseout="))
    }

    @Test("Hover true actions go to onmouseover")
    func hoverTrueGoesToMouseOver() async throws {
        let element = Text("Hover me")
            .onHover { isHovering in
                if isHovering {
                    ShowAlert(message: "over")
                } else {
                    ShowAlert(message: "out")
                }
            }

        let output = element.markupString()

        #expect(output.contains(#"onmouseover="alert('over')"#))
        #expect(output.contains(#"onmouseout="alert('out')"#))
    }

    @Test("onHover works on inline elements")
    func hoverOnInlineElement() async throws {
        let element = Emphasis("Hover me")
            .onHover { isHovering in
                if isHovering {
                    ShowAlert(message: "in")
                } else {
                    ShowAlert(message: "out")
                }
            }

        let output = element.markupString()

        #expect(output.contains("onmouseover="))
        #expect(output.contains("onmouseout="))
    }
}
