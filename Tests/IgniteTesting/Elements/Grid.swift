//
//  Grid.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Grid` element.
@Suite("Grid Tests")
@MainActor
struct GridTests {
    init() throws {
        try PublishingContext.initialize(for: TestSite(), from: #filePath)
    }

    @Test("List with three images")
    func gridWithThreeImages() async throws {
        let element = Grid {
            Image("/images/photos/shades.jpg", description: "A pair of sunglasses.")
                .resizable()

            Image("/images/photos/stack.jpg", description: "A door partly open.")
                .resizable()

            Image("/images/photos/wind.jpg", description: "A windy day.")
                .resizable()
        }
        let output = element.render()

        #expect(output ==
        """
        <div class="row"><div class=" col"><img alt="A pair of sunglasses." src="/images/photos/shades.jpg" \
        class="img-fluid" /></div><div class=" col"><img alt="A door partly open." src="/images/photos/stack.jpg" \
        class="img-fluid" /></div><div class=" col"><img alt="A windy day." src="/images/photos/wind.jpg" \
        class="img-fluid" /></div></div>
        """)
    }

    @Test("List with three images and width")
    func gridWithThreeImagesAndWidth() async throws {
        let element = Grid {
            Image("/images/photos/shades.jpg", description: "A pair of sunglasses.")
                .resizable()
                .width(4)

            Image("/images/photos/stack.jpg", description: "A door partly open.")
                .resizable()
                .width(4)

            Image("/images/photos/wind.jpg", description: "A windy day.")
                .resizable()
                .width(4)
        }

        let output = element.render()

        #expect(output ==
        """
        <div class="row"><div class=" col-md-4"><img alt="A pair of sunglasses." src="/images/photos/shades.jpg" \
        class="img-fluid" /></div><div class=" col-md-4"><img alt="A door partly open." \
        src="/images/photos/stack.jpg" class="img-fluid" /></div><div class=" col-md-4">\
        <img alt="A windy day." src="/images/photos/wind.jpg" class="img-fluid" /></div></div>
        """)
    }

    @Test("List with four elements of width 4, should wrap")
    func gridWithWrapping() async throws {
        let element = Grid {
            Image("/images/photos/shades.jpg", description: "A pair of sunglasses.")
                .resizable()
                .width(4)

            Image("/images/photos/stack.jpg", description: "A door partly open.")
                .resizable()
                .width(4)

            Image("/images/photos/rug.jpg", description: "A nice rug.")
                .resizable()
                .width(4)

            Image("/images/photos/car.jpg", description: "The window of a car.")
                .resizable()
                .width(4)
        }

        let output = element.render()

        #expect(output ==
        """
        <div class="row"><div class=" col-md-4"><img alt="A pair of sunglasses." src="/images/photos/shades.jpg" \
        class="img-fluid" /></div><div class=" col-md-4"><img alt="A door partly open." src="/images/photos/stack.jpg" \
        class="img-fluid" /></div><div class=" col-md-4"><img alt="A nice rug." src="/images/photos/rug.jpg" \
        class="img-fluid" /></div><div class=" col-md-4"><img alt="The window of a car." src="/images/photos/car.jpg" \
        class="img-fluid" /></div></div>
        """)
    }

    @Test("List with four elements of width 4, should wrap")
    func gridWithWrappingTwoColors() async throws {
        let element = Grid {
            Image("/images/photos/shades.jpg", description: "A pair of sunglasses.")
                .resizable()

            Image("/images/photos/stack.jpg", description: "A door partly open.")
                .resizable()

            Image("/images/photos/rug.jpg", description: "A nice rug.")
                .resizable()

            Image("/images/photos/car.jpg", description: "The window of a car.")
                .resizable()
        }
        .columns(2)

        let output = element.render()

        #expect(output ==
        """
        <div class="row row-cols-1 row-cols-md-2"><div class=" col"><img alt="A pair of sunglasses." \
        src="/images/photos/shades.jpg" class="img-fluid" /></div><div class=" col"><img alt="A door partly open." \
        src="/images/photos/stack.jpg" class="img-fluid" /></div><div class=" col"><img alt="A nice rug." \
        src="/images/photos/rug.jpg" class="img-fluid" /></div><div class=" col"><img alt="The window of a car." \
        src="/images/photos/car.jpg" class="img-fluid" /></div></div>
        """)
    }
}
