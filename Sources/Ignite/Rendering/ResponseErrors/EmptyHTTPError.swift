//
// EmptyHTTPError.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Represents the absence of a HTTP error.
struct EmptyHTTPError: HTTPError {
    var filename: String { "" }
    var title: String { "" }
    var description: String { "" }
}
