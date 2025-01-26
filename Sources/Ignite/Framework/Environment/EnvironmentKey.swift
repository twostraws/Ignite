//
// EnvironmentKey.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

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
public protocol EnvironmentKey {
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

/// A key for accessing available themes in the environment.
public struct ThemesKey: EnvironmentKey {
    /// The default empty array of themes.
    public static var defaultValue: [any Theme] = []
}

/// A key for accessing the site author in the environment
public struct SiteAuthorKey: EnvironmentKey {
    /// The default empty string for site author
    public static var defaultValue: String = ""
}

/// A key for accessing the site name in the environment
public struct SiteNameKey: EnvironmentKey {
    /// The default empty string for site name
    public static var defaultValue: String = ""
}

/// A key for accessing the site title suffix in the environment
public struct SiteTitleSuffixKey: EnvironmentKey {
    /// The default empty string for site title suffix
    public static var defaultValue: String = ""
}

/// A key for accessing the site description in the environment
public struct SiteDescriptionKey: EnvironmentKey {
    /// The default nil value for site description
    public static var defaultValue: String?
}

/// A key for accessing the site language in the environment
public struct SiteLanguageKey: EnvironmentKey {
    /// The default English language for the site
    public static var defaultValue: Language = .english
}

/// A key for accessing the site URL in the environment
public struct SiteURLKey: EnvironmentKey {
    /// The default example.com URL for the site
    public static var defaultValue: URL = URL(static: "https://example.com")
}

/// A key for accessing the site favicon in the environment
public struct FaviconKey: EnvironmentKey {
    /// The default nil value for favicon
    public static var defaultValue: URL?
}

/// A key for accessing the Bootstrap icons configuration in the environment
public struct BuiltInIconsKey: EnvironmentKey {
    /// The default local Bootstrap configuration for built-in icons
    public static var defaultValue: BootstrapOptions = .localBootstrap
}
