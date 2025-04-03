//
// EmptyResponseError.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Represents the absence of a response error.
struct EmptyResponseError: ResponseError {
    var filename: String { "" }
    var title: String { "" }
    var description: String { "" }
}
