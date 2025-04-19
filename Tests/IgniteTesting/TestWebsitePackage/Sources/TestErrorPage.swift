//
// TestErrorPage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Ignite

struct TestErrorPage: ErrorPage {

    var title: String = "Test Error Page"
    var description: String = "Test Error Page Description"

    var body: some HTML {
        EmptyHTML()
    }
}
