//
// URL-Relative.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension URL {
    /// Creates a relative URL by using another URL as its base.
    /// - Parameter other: The base URL to compare against.
    /// - Returns: A relative URL.
    func relative(to other: URL) -> String {
        let basePath = other.path()
        let thisPath = path()
        let result = thisPath.trimmingPrefix(basePath)

        return String(result)
    }
}
