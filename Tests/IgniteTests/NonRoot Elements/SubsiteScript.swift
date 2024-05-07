//
// SubsiteScript.swift                              
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

import XCTest
@testable import Ignite

/// Tests for the `title` element.
final class SubsiteScriptTests: ElementTest {

    func test_empty() {
        let element = Script(file: "/js/bootstrap.bundle.min.js").render(context: publishingSubsiteContext)
        let output = element.render(context: publishingSubsiteContext)

        XCTAssertEqual(output, "<script src=\"/subsite/js/bootstrap.bundle.min.js\"></script>")
    }

}
