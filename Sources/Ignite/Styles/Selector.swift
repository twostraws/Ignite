//
// Selector.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A type that represents a CSS selector and its conditions.
public struct Selector: Hashable {
    /// The conditions that must be met for this selector to apply.
    let conditions: [String]
}
