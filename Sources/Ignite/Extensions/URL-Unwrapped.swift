//
// URL-Unwrapped.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension URL {
    /// Creates URLs from static strings, which will only fail if you have made
    /// a significant typing error.
    public init(_ string: StaticString) {
        if let created = URL(string: String(describing: string)) {
            self = created
        } else {
            fatalError("Attempted to create a URL from an invalid string: \(string)")
        }
    }
}
