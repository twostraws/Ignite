//
// ThemedPage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// The `LayoutPage` protocol allows all pages on your site, whether static,
/// content-driven, or layouts, to adapt to a theme of your design.
@MainActor
public protocol ThemePage: EnvironmentReader {
    /// The type of theme you want this page to use.
    associatedtype ThemeType: Theme

    /// The theme to apply to this page.
    var theme: ThemeType { get }
}

/// Default implementation that provides a missing layout when no theme is specified.
/// This allows the framework to detect when a page needs a theme applied.
public extension ThemePage {
    var theme: MissingTheme { MissingTheme() }
}

/// Default implementation that provides access to the current environment values.
/// The environment store maintains global state and settings that can be accessed
/// throughout the page rendering process.
public extension ThemePage {
    var environment: EnvironmentValues {
        get { EnvironmentStore.current }
        set { EnvironmentStore.current = newValue }
    }
}
