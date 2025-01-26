//
//  Array-ContainsLocation.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Array-ContainsLocation` extension.
@Suite("Array-ContainsLocation Tests")
@MainActor
struct ArrayContainsLocationTests {
    @Test("Checks if an array of 'Location' types contains a specific path")
    func testIfArrayContainsPath() async throws {
        // Given
        let location1 = Location(path: "https://www.example.com/home", priority: 1.0)
        let location2 = Location(path: "https://www.example.com/contact", priority: 0.8)
        let location3A = Location(path: "https://www.example.com/about-us", priority: 0.6) // duplicate
        let location3B = Location(path: "https://www.example.com/about-us", priority: 0.6) // duplicate
        let location4 = Location(path: "https://www.example.com/the-truth", priority: 2.0)
        // When
        let someLocations = [location1, location2, location3A, location3B, location4]
        // Then #1
        #expect(someLocations.contains("https://www.example.com/home") == true)
        #expect(someLocations.contains("https://www.example.com/contact") == true)
        #expect(someLocations.contains("https://www.example.com/about-us") == true)
        #expect(someLocations.contains("https://www.example.com/the-truth") == true)
        // Then #2
        #expect(someLocations.contains("https://www.example.com/our-lies") == false)
        #expect(someLocations.contains("https://www.example.com/the-Truth") == false)
        #expect(someLocations.contains("random string") == false)
        #expect(someLocations.contains("") == false)
    }

    @Test("Checks if an array of randomly created 'Location' types contains the expected number of paths")
    func testIfArrayContainsRandomlyChosenPath() async throws {
        // Given
        let testPaths = [
            "https://www.example.com",
            "https://www.example.com/home",
            "https://www.example.com/contact",
            "https://www.example.com/about-us",
            "https://www.example.com/the-truth",
            "https://www.example.com/the-Truth",
            "http://www.example.com/the-truth",
            "random string",
            ""
        ]

        // can use a set if Location: Hashable
        var randomLocations = [Location]()
        let expectedNumberOfPaths = Int.random(in: 1...testPaths.count)

        for _ in 1...expectedNumberOfPaths {
            let location = Location(
                path: testPaths.randomElement()!,
                priority: Double.random(in: 0...1)
            )
            randomLocations.append(location)
        }

        // When
        var actualNumberOfPaths = 0
        // while loop to catch duplicates
        while randomLocations.count > 0 {
            for path in testPaths where randomLocations.contains(path) {
                let index = randomLocations.firstIndex(where: { $0.path == path })!
                randomLocations.remove(at: index)
                actualNumberOfPaths += 1
            }
        }

        // Then
        #expect(actualNumberOfPaths == expectedNumberOfPaths)
    }
}
