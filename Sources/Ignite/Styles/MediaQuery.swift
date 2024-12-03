//
// MediaQuery.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that represents a CSS media query condition and its associated value.
public struct MediaQuery: Hashable {
    /// The conditions that must be met for this media query to apply.
    let conditions: [String]
}
