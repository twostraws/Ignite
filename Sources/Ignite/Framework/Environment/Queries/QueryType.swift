//
// QueryType.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A protocol that defines how environment values are represented in CSS media queries.
public protocol QueryType: RawRepresentable where RawValue == String {
    /// The CSS prefix used for this environment value.
    var key: String { get }

    /// The CSS media query feature name for this environment value.
    var query: String { get }
}
