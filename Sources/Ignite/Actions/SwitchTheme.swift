//
// SwitchTheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An action that switches between themes by updating data-bs-theme
/// and data-theme-state attributes on the document root.
public struct SwitchTheme: Action {
    let themeID: String

    /// Creates a new theme switching action
    /// - Parameter themeID: The ID of the theme to switch to (will be automatically sanitized)
    public init(_ themeID: String) {
        self.themeID = themeID.kebabCased()
    }

    /// Compiles the action into JavaScript code that calls the switchTheme function
    /// - Returns: JavaScript code to execute the theme switch
    public func compile() -> String {
        "igniteSwitchTheme('\(themeID)');"
    }
}
