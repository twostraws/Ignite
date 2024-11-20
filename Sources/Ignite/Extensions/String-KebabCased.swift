//
// String-Kebab.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension String {
    /// Converts string to kebab-case (e.g. "camelCase" -> "camel-case")
    func kebabCased() -> String {
        self
            .replacing(
                #/([a-z0-9])([A-Z])/#,
                with: { match in
                    "\(match.1)-\(match.2)"
                }
            )
            .lowercased()
            .replacing(/\s+/, with: "-")
    }
}
