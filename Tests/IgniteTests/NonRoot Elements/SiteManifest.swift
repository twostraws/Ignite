//
// SubsiteManifest.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

import XCTest
@testable import Ignite

/// Tests manifest file generation.
final class SubsiteManifestTests: GeneratorTest {
    func test_generator() {
        let generator = ManifestGenerator(site: testSite)
        let output = generator.generateManifest()
        
        let expected = """
        {
            "id":"/?source=pwa",
            "short_name":"TestSite",
            "scope":"/",
            "start_url":"/?source=pwa",
            "icons":[],
            "background_color": "#000000",
            "orientation":"any",
            "categories":[],
            "display":"standalone",
            "theme_color":"#B22222",
            "name":"My Test Site",
            "language":"en"
        }
        """
        
        /// Because the output is JSON equality can't be established as Strings
        /// Test is kept for use when reading output values of assertion.
//        XCTAssertEqual(output, expected)
        
        /// JSON strings are converted into dictionaries.
        let outputDict = try! jsonStringToDictionary(output)
        let expectedDict = try! jsonStringToDictionary(expected)
        
        /// Dictionaries are compared for equality.
        XCTAssertTrue(dictionariesAreEqual(outputDict, expectedDict))
    }
}

