//
// String-StrippingTags.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension String {
    /// Removes all HTML tags from a string, so it's safe to use as plain-text.
    func strippingTags() -> String {
        self.replacing(#/<.*?>/#, with: "")
    }
}
