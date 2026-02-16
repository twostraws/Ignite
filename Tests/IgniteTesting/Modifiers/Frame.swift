//
//  Frame.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Frame` modifier.
@Suite("Frame Tests")
@MainActor
class FrameTests: IgniteTestSuite {
    @Test("Explicit width/height frame applies styles directly to HTML content")
    func htmlFrameAppliesDirectStyles() async throws {
        let output = Text("Hello")
            .frame(width: 120, height: 45)
            .markupString()

        #expect(output == #"<p style="width: 120px; height: 45px">Hello</p>"#)
    }

    @Test("Max width without explicit width injects width 100 percent for HTML content")
    func maxWidthInjectsResponsiveWidth() async throws {
        let output = Text("Hello")
            .frame(maxWidth: 320)
            .markupString()

        #expect(output == #"<p style="width: 100%; max-width: 320px">Hello</p>"#)
    }

    @Test("Alignment wraps non-image content in a flex container")
    func alignmentWrapsNonImageContent() async throws {
        let output = Text("Hello")
            .frame(width: 150, alignment: .bottomTrailing)
            .markupString()

        #expect(output.contains(#"<div style="display: flex;"#))
        #expect(output.contains("overflow: hidden"))
        #expect(output.contains("align-items: flex-end"))
        #expect(output.contains("justify-content: flex-end"))
        #expect(output.contains("width: 150px"))
        #expect(output.contains("align-self: flex-end"))
        #expect(output.contains("justify-self: flex-end"))
        #expect(!output.contains("flex-direction: column"))
    }

    @Test("Image alignment adds column flex direction and applies dimensions to image and wrapper")
    func imageAlignmentUsesColumnLayout() async throws {
        let output = AnyHTML(Image("/images/test.jpg", description: "Test"))
            .frame(width: 120, alignment: .center)
            .markupString()

        #expect(output.contains("<div"))
        #expect(output.contains("flex-direction: column"))
        #expect(output.contains("align-items: center"))
        #expect(output.contains("justify-content: center"))
        #expect(output.contains("align-self: center"))
        #expect(output.contains("justify-self: center"))
        #expect(output.contains("width: 120px"))
        #expect(output.contains(#"src="/images/test.jpg""#))
    }

    @Test("Inline frame styles inline elements without introducing wrapper elements")
    func inlineFrameAppliesStylesDirectly() async throws {
        let output = Emphasis("Hello")
            .frame(width: 90)
            .markupString()

        #expect(output == #"<em style="width: 90px">Hello</em>"#)
    }
}
