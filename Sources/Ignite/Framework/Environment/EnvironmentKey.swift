//
// EnvironmentKey.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A protocol that defines how environment values are stored and accessed.
///
/// Environment keys provide default values for environment settings. For example:
///
/// ```swift
/// public enum ThemeKey: EnvironmentKey {
///     public static var defaultValue: Layout = DefaultLightTheme()
/// }
/// ```
@MainActor
public protocol EnvironmentKey: Sendable {
    /// The type of value associated with this environment key.
    associatedtype Value: Sendable
    
    /// The default value to use when no explicit value is set.
    static var defaultValue: Self.Value { get }
}

/// A key for accessing all markdown content in the environment.
public enum AllContentKey: EnvironmentKey {
    /// The default empty array of markdown content.
    public static let defaultValue: [Content] = []
}

/// A key for accessing the site configuration in the environment.
public enum ConfigurationKey: EnvironmentKey {
    /// The default site configuration.
    public static var defaultValue: SiteConfiguration = .init()
}

/// A key for accessing available themes in the environment.
public struct ThemesKey: EnvironmentKey {
    /// The default empty array of themes.
    public static var defaultValue: [any Theme] = []
}
