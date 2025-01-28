//
// URL-DecodedPath.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension URL {
    /// The URL path without percent encoding.
    var decodedPath: String {
        self.path(percentEncoded: false)
    }
}
