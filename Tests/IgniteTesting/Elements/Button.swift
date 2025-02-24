//
//  Button.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import SwiftUI
import Testing

@testable import Ignite

/// Tests for the `Button` element.
@Suite("Button Tests")
@MainActor
class ButtonTests: IgniteTestSuite {
    @Test("Button")
    func button() async throws {
        let element = Text {
            Button("Say Hello") {
                ShowAlert(message: "Hello, world!")
            }
            .role(.primary)
        }

        let output = element.render()

        #expect(output == """
        <p><button type=\"button\" \
        class=\"btn btn-primary\" \
        onclick=\"alert('Hello, world!')\">Say Hello</button></p>
        """)
    }

    @Test("Show Text")
    func showText() async throws {
        let button1 = Text {
            Button("Show First Text") {
                ShowElement("FirstText")
                HideElement("SecondText")
            }
            .role(.primary)
        }

        let button2 = Text {
            Button("Show Second Text") {
                HideElement("FirstText")
                ShowElement("SecondText")
            }
            .role(.primary)
        }

        let text1 = Text("This is the first text.")
            .font(.title3)
            .id("FirstText")

        let text2 = Text("This is the second text.")
            .font(.title3)
            .id("SecondText")
            .hidden()

        let outputButton1 = button1.render()
        let outputButton2 = button2.render()
        let outputText1 = text1.render()
        let outputText2 = text2.render()

        #expect(outputButton1 == """
        <p><button type=\"button\" class=\"btn btn-primary\" \
        onclick=\"document.getElementById('FirstText').classList.remove('d-none'); \
        document.getElementById('SecondText').classList.add('d-none')\">Show First \
        Text</button></p>
        """)

        #expect(outputButton2 == """
        <p><button type=\"button\" \
        class=\"btn btn-primary\" onclick=\"document.getElementById('FirstText').classList.add('d-none'); \
        document.getElementById('SecondText').classList.remove('d-none')\">Show Second Text</button></p>
        """)

        #expect(outputText1 == "<h3 id=\"FirstText\">This is the first text.</h3>")

        #expect(outputText2 == "<h3 id=\"SecondText\" class=\"d-none\">This is the second text.</h3>")
    }

    @Test("Link Button")
    func linkButton() async throws {
        let element = Text {
            Link("This is a link button", target: self.contentExamples())
                .linkStyle(.button)
        }

        let output = element.render()

        #expect(output == """
        <p><a href=\"https://www.hackingwithswift.com\" \
        class=\"btn btn-primary\">This is a link button</a></p>
        """)
    }

    @Test("Disabled Button")
    func disabledButton() async throws {
        let button = Button().disabled()
        let output = button.render()
        #expect(output == #"<button type="button" disabled class="btn"></button>"#)
    }

    // MARK: Targets

    func contentExamples() -> URL {
        URL(string: "https://www.hackingwithswift.com")!
    }
}
