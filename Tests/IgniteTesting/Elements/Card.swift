//
//  Card.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Card` element.
@Suite("Card Tests")
@MainActor
class CardTests: IgniteTestSuite {
    @Test("Basic Card")
    func basicCard() async throws {
        let element = Card {
            "Some text wrapped in a card"
        }

        let output = element.render()

        #expect(output.string == """
        <div class="card"><div class="card-body">Some text wrapped in a card</div></div>
        """)
    }

    @Test("Basic Card with Image")
    func basicCardWithImage() async throws {
        let element = Card(imageName: "dog.jpg") {
            "Some text wrapped in a card"
        }

        let output = element.render()

        #expect(output.string == """
        <div class="card"><img src="dog.jpg" alt="" class="card-img-top" />\
        <div class="card-body">Some text wrapped in a card</div></div>
        """)
    }

    @Test("Basic Card with Header and Footer")
    func basicCardWithHeaderAndFooter() async throws {
        let element = Card {
            "Some text wrapped in a card"
        } header: {
            "Header"
        } footer: {
            "A footer"
        }

        let output = element.render()

        #expect(output.string == """
        <div class="card"><div class="card-header">Header</div><div class="card-body">Some text wrapped in a card</div>\
        <div class="card-footer text-body-secondary">A footer</div></div>
        """)
    }

    @Test("Complex Card")
    func complexCard() async throws {
        let element = Card(imageName: "/images/photos/dishwasher.jpg") {
            Text("Before putting your dishes into the dishwasher, give them a quick pre-clean.")

            Link("Back to the homepage", target: "/")
                .linkStyle(.button)
        }
        .frame(maxWidth: 500)

        let output = element.render()

        #expect(output.string == """
        <div class="card" style="width: 100%; max-width: 500px">\
        <img src="/images/photos/dishwasher.jpg" alt="" class="card-img-top" /><div class="card-body">\
        <p class="card-text">Before putting your dishes into the dishwasher, give them a quick pre-clean.</p>\
        <a href="/" class="card-link btn btn-primary">Back to the homepage</a></div></div>
        """)
    }

    @Test("Card Styles", arguments: zip(
        CardStyle.allCases,
        ["card", "card text-bg-default", "card border-default"]))
    func cardStyles(style: CardStyle, expectedClass: String) async throws {
        let element = Card {
            "Placeholder"
        }
        .cardStyle(style)

        let output = element.markupString()

        #expect(output == """
        <div class="\(expectedClass)"><div class="card-body">Placeholder</div></div>
        """)
    }

    @Test("Card Content Position: Top")
    func contentPositionTop() async throws {
        let element = Card(imageName: "image.jpg") {
            "Placeholder"
        }
        .contentPosition(.top)

        let output = element.markupString()

        #expect(output == """
        <div class="card"><div class="card-body">Placeholder</div>\
        <img src="image.jpg" alt="" class="card-img-bottom" /></div>
        """)
    }

    @Test("Card Content Position: Bottom")
    func contentPositionBottom() async throws {
        let element = Card(imageName: "image.jpg") {
            "Placeholder"
        }
        .contentPosition(.bottom)

        let output = element.markupString()

        #expect(output == """
        <div class="card"><img src="image.jpg" alt="" class="card-img-top" />\
        <div class="card-body">Placeholder</div></div>
        """)
    }

    @Test("Card Content Position: Overlay")
    func contentPositionOverlay() async throws {
        let element = Card(imageName: "image.jpg") {
            "Placeholder"
        }
        .contentPosition(.overlay)

        let output = element.markupString()

        #expect(output == """
        <div class="card"><img src="image.jpg" alt="" class="card-img" />\
        <div class="card-img-overlay text-start align-content-start">Placeholder</div></div>
        """)
    }
}
