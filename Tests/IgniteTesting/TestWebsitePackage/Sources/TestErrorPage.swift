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

    let errorChecker: (HTTPError) -> Void

    init(
        title: String = "Test Error Page",
        description: String = "Test Error Page Description",
        errorChecker: @escaping (HTTPError) -> Void = { _ in }
    ) {
        self.title = title
        self.description = description
        self.errorChecker = errorChecker
    }

    var body: some HTML {
        ErrorChecker { errorChecker(error) }
    }

    struct ErrorChecker: HTML {
        init(handler: @escaping () -> Void) {
            handler()
        }

        var body: some HTML {
            EmptyHTML()
        }
    }
}
