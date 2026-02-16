//
//  Carousel.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `Carousel` element.
@Suite("Carousel Tests")
@MainActor
class CarouselTests: IgniteTestSuite {
    @Test("Carousel renders indicators and controls targeting its generated ID")
    func generatedIDIsUsedEverywhere() async throws {
        let element = Carousel {
            Slide { Text("First") }
            Slide { Text("Second") }
        }

        let output = element.markupString()
        let carouselID = firstCarouselID(in: output)

        #expect(carouselID != nil)
        #expect(output.contains(#"class="carousel-indicators""#))
        #expect(output.contains(#"data-bs-slide-to="0""#))
        #expect(output.contains(#"data-bs-slide-to="1""#))
        #expect(output.contains(#"aria-label="Slide 1""#))
        #expect(output.contains(#"aria-label="Slide 2""#))
        #expect(output.contains(#"data-bs-slide="prev""#))
        #expect(output.contains(#"data-bs-slide="next""#))

        if let carouselID {
            let target = "data-bs-target=\"#\(carouselID)\""
            #expect(countOccurrences(of: target, in: output) == 4)
        }
    }

    @Test("Custom move style and interval generate transform transition without fade class")
    func customMoveStyleAndInterval() async throws {
        let element = Carousel {
            Slide { Text("One") }
            Slide { Text("Two") }
        }
        .carouselStyle(.move(0.5, curve: .linear))
        .slideDuration(0.5)

        let output = element.markupString()

        #expect(output.contains(#"data-bs-interval="500""#))
        #expect(output.contains("transition: transform 0.5s linear"))
        #expect(!output.contains("carousel-fade"))
    }

    @Test("Custom crossfade style adds fade class and combined transform/opacity transition")
    func customCrossfadeStyle() async throws {
        let element = Carousel {
            Slide { Text("One") }
            Slide { Text("Two") }
        }
        .carouselStyle(.crossfade(0.25, curve: .easeOut))

        let output = element.markupString()

        #expect(output.contains("carousel-fade"))
        #expect(output.contains("transition: transform 0.25s ease-out, opacity 0.25s ease-out"))
    }

    @Test("Sequence initializer creates one indicator per item")
    func sequenceInitializerCreatesSlides() async throws {
        let items = ["First", "Second", "Third"]
        let element = Carousel(items) { item in
            Slide { Text(item) }
        }

        let output = element.markupString()

        #expect(countOccurrences(of: #"data-bs-slide-to=""#, in: output) == items.count)
        #expect(output.contains(#"data-bs-slide-to="2""#))
    }

    private func firstCarouselID(in source: String) -> String? {
        source.firstMatch(of: /id="(carousel[^"]+)"/).map { String($0.1) }
    }

    private func countOccurrences(of substring: String, in source: String) -> Int {
        guard !substring.isEmpty else { return 0 }

        var count = 0
        var searchStart = source.startIndex

        while let range = source.range(of: substring, range: searchStart..<source.endIndex) {
            count += 1
            searchStart = range.upperBound
        }

        return count
    }
}
