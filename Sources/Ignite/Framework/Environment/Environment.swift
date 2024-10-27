//
// Environment.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A namespace containing media query based environment values for controlling element visibility.
public enum Environment {
    /// Defines the requirements for a value that can be used in media query-based display rules.
    public protocol MediaQueryValue: RawRepresentable where RawValue == String {
        /// The CSS prefix used for this environment value (e.g. "color-scheme").
        var key: String { get }

        /// The CSS media query feature name for this environment value (e.g. "prefers-color-scheme").
        var query: String { get }
    }
}
