//
// SubsiteBody.swift                                
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

import XCTest
@testable import Ignite

/// Tests for the `title` element.
final class SubsiteBodyTests: ElementTest {

    func test_body_simple() {
        let element = Body(for: Page(title: "TITLE", description: "DESCRIPTION",
                                     url: URL("http://www.yoursite.com/subsite"),
                                     body: Text("TEXT")))
        let output = element.render(context: publishingSubsiteContext)

        XCTAssertEqual(output, """
            <body><div class=\"col-sm-10 mx-auto\"><p>TEXT</p>\
            </div><script src=\"/subsite/js/bootstrap.bundle.min.js\"></script>\
            <script src=\"/subsite/js/syntax-highlighting.js\"></script></body>
            """)
    }

}
