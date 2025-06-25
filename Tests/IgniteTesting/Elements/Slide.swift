//
//  Slide.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Slide` element.
@Suite("Slide Tests")
@MainActor
class SlideTests: IgniteTestSuite {
    @Test("Slide with Background Image")
    func slideWithBackgroundImage() async throws {
        let slide = Slide(background: "/images/dog.jpg")
        let output = slide.render().string

        #expect(output == """
        <div class="carousel-item" style="background-color: black">\
        <img src="/images/dog.jpg" alt="" class="d-block w-100" \
        style="height: 100%; object-fit: cover; opacity: 1" />\
        <div class="container">\
        <div class="carousel-caption">\
        </div>\
        </div>\
        </div>
        """)
    }

    @Test("Slide with Items")
    func slideWithItems() async throws {
        let slide = Slide {
            Text("Item 1")
            Text("Item 2")
        }
        let output = slide.render().string

        #expect(output == """
        <div class=\"carousel-item\" style=\"background-color: black\">\
        <div class=\"container\">\
        <div class=\"carousel-caption\">\
        <p>Item 1</p>\
        <p>Item 2</p>\
        </div>\
        </div>\
        </div>
        """)
    }

    @Test("Slide with Background Opacity")
    func slideWithBackgroundOpacity() async throws {
        let slide = Slide(background: "/images/dog.jpg").backgroundOpacity(0.5)
        let output = slide.render().string

        #expect(output == """
        <div class="carousel-item" style="background-color: black">\
        <img src="/images/dog.jpg" alt="" class="d-block w-100" \
        style="height: 100%; object-fit: cover; opacity: 0.5" />\
        <div class="container">\
        <div class="carousel-caption">\
        </div>\
        </div>\
        </div>
        """)
    }
}
