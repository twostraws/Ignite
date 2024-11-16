//
// URL-RemovingWWW.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension URL {
    /// Removes "www" from a URL host if it exists. Useful for social sharing,
    /// where "Read more on example.com" reads better than "Read more on
    /// www.example.com".
    var removingWWW: String? {
        host()?.replacing(#/^www\./#, with: "")
    }
}
