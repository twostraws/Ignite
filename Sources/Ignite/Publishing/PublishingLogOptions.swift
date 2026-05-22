//
// PublishingLogOptions.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Controls which publishing diagnostics Ignite writes to the console.
public struct PublishingLogOptions: OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// Progress and success messages emitted during publishing.
    public static let notices = Self(rawValue: 1 << 0)

    /// Non-fatal publishing warnings collected while generating the site.
    public static let warnings = Self(rawValue: 1 << 1)

    /// Non-fatal publishing errors collected while generating the site.
    public static let errors = Self(rawValue: 1 << 2)

    /// The default set of publishing diagnostics.
    public static let standard: Self = [.notices, .warnings, .errors]

    /// Suppresses publishing diagnostics.
    public static let silent: Self = []
}
