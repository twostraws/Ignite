//
// ThemedPage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// The `ThemedPage` protocol allows all pages on your site, whether static,
/// content-driven, or layouts, to adapt to a theme of your design.
public protocol ThemedPage {
    /// The type of theme you want this page to use.
    associatedtype ThemeType: Theme

    /// The theme to apply to this page.
    var theme: ThemeType { get }
}
