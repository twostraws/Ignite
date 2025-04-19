//
// TestPage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Ignite

/// An example page used in tests.
struct TestPage: StaticPage {
    var title = "Home"

    var body: some HTML {
        Text("Hello, World!")
    }
}
