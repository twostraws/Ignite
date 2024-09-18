//
// SubsiteMapkit.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

import XCTest
@testable import Ignite

/// Tests manifest file generation.
final class SubsiteMapkitTest: GeneratorTest {
    func test_generator() {
        let generator = MapKitJSGenerator(site: testSite)
        let output = generator.generateLoadMapScript(library: testSite.mapKitLibraries!)

        let expected = """
                <script
                       src="https://cdn.apple-mapkit.com/mk/5.x.x/mapkit.core.js">
                       crossorigin="anonymous"
                       async="async"
                       data-callback="initMapKit"
                       data-token="eyJraWQiOiI0UkRRVVRIMjJOIiwidHlwIjoiSldUIiwiYWxnIjoiRVMyNTYifQ.eyJpc3MiOiIyTVA4UVdLN1I2IiwiaWF0IjoxNzI1NTk4NDM2LCJvcmlnaW4iOiJpZ25pdGVzYW1wbGVzLmhhY2tpbmd3aXRoc3dpZnQuY29tIn0.UgaNnmSfiQsD6D23LC7-_5mEY2p_hvtM_nPOfwtV48UWl1YPX5o2YgvAJpTdjMzEQZ-IPapuIXJ7DJ4N4kdo8w"
                       data-libraries="map,annotations,services"
                       </script>
        """.replacingOccurrences(of: " ", with: "")

        /// Because the output is JSON equality can't be established as Strings
        /// Test is kept for use when reading output values of assertion.
        XCTAssertEqual(output, expected)
    }
}
