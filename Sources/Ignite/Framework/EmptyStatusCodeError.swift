//
// File.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Represents the absence of a status code error.
struct EmptyStatusCodeError: StatusCodeError {
    var filename: String { "" }
    var title: String { "" }
    var description: String { "" }
}
