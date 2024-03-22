//
// Array-ContainsLocation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension Array where Element == Location {
    /// An extension that lets us determine whether one path is contained inside
    /// An array of `Location` objects.
    func contains(_ path: String) -> Bool {
        self.contains {
            $0.path == path
        }
    }
}
