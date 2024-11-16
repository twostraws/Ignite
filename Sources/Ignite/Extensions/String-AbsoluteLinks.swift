//
// String-AbsoluteLinks.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension String {
    /// Converts links and image sources from relative links to absolute.
    /// - Parameter url: The base URL, which is usually your web domain.
    /// - Returns: The adjusted string, where all relative links are absolute.
    func makingAbsoluteLinks(relativeTo url: URL) -> String {
        var absolute = self

        // Fix images.
        absolute.replace(#/src="(?<path>\/[^"]+)/#) { match in
            let fullURL = url.appending(path: match.output.path).absoluteString
            return "src=\"\(fullURL)"
        }

        // Fix links.
        absolute.replace(#/href="(?<path>\/[^"]+)/#) { match in
            let fullURL = url.appending(path: match.output.path).absoluteString
            return "href=\"\(fullURL)"
        }

        return absolute
    }
}
