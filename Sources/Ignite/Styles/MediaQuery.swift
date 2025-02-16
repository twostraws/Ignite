//
// MediaQuery.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that represents different media query conditions for applying conditional styles.
public enum MediaQuery: Sendable {
    /// Applies styles based on the user's preferred color scheme.
    case colorScheme(ColorScheme)

    /// Applies styles based on the user's motion preferences.
    case motion(Motion)

    /// Applies styles based on the user's contrast preferences.
    case contrast(Contrast)

    /// Applies styles based on the user's transparency preferences.
    case transparency(Transparency)

    /// Applies styles based on the device orientation.
    case orientation(Orientation)

    /// Applies styles based on the web application's display mode.
    case displayMode(DisplayMode)

    /// Applies styles based on the current theme.
    case theme(String)

    /// Applies styles based on viewport width breakpoints
    case breakpoint(Breakpoint)

    /// The user's preferred color scheme options.
    public enum ColorScheme: Sendable {
        /// Dark mode preference
        case dark
        /// Light mode preference
        case light
    }

    /// The user's motion preference options.
    public enum Motion: Sendable {
        /// Reduced motion preference
        case reduced
        /// Standard motion preference
        case allowed
    }

    /// The user's contrast preference options.
    public enum Contrast: Sendable {
        /// A custom contrast preference
        case custom
        /// High contrast preference
        case high
        /// Low contrast preference
        case low
        /// Unspecified contrast preference
        case noPreference
    }

    /// The user's transparency preference options.
    public enum Transparency: Sendable {
        /// Reduced transparency preference
        case reduced
        /// Standard transparency preference
        case normal
    }

    /// The device orientation options.
    public enum Orientation: Sendable {
        /// Portrait orientation
        case portrait
        /// Landscape orientation
        case landscape
    }

    /// The web application display mode options.
    public enum DisplayMode: Sendable {
        /// Standard browser mode
        case browser
        /// Full screen mode
        case fullscreen
        /// Minimal UI mode
        case minimalUI
        /// Picture-in-picture mode
        case pip
        /// Standalone application mode
        case standalone
        /// Window controls overlay mode
        case windowControlsOverlay
    }

    /// The user's breakpoint preference options.
    public enum Breakpoint: String, Sendable {
        /// Small breakpoint (typically ≥576px)
        case small = "sm"
        /// Medium breakpoint (typically ≥768px)
        case medium = "md"
        /// Large breakpoint (typically ≥992px)
        case large = "lg"
        /// Extra large breakpoint (typically ≥1200px)
        case xLarge = "xl"
        /// Extra extra large breakpoint (typically ≥1400px)
        case xxLarge = "xxl"
    }

    /// Generates the CSS media query string for this condition
    /// - Parameter theme: The theme to use for breakpoint values
    /// - Returns: A CSS media query string
    @MainActor func query(with theme: Theme) -> String {
        switch self {
        case .colorScheme(let scheme):
            css(for: scheme, using: theme)

        case .motion(let motion):
            css(for: motion, using: theme)

        case .contrast(let contrast):
            css(for: contrast, using: theme)

        case .transparency(let transparency):
            css(for: transparency, using: theme)

        case .orientation(let orientation):
            css(for: orientation, using: theme)

        case .displayMode(let mode):
            css(for: mode, using: theme)

        case .theme(let id):
            "data-theme-state=\"\(id.kebabCased())\""

        case .breakpoint(let breakpoint):
            css(for: breakpoint, using: theme)
        }
    }

    @MainActor func css(for scheme: ColorScheme, using theme: Theme) -> String {
        switch scheme {
        case .dark: "prefers-color-scheme: dark"
        case .light: "prefers-color-scheme: light"
        }
    }

    @MainActor func css(for motion: Motion, using theme: Theme) -> String {
        switch motion {
        case .reduced: "prefers-reduced-motion: reduce"
        case .allowed: "prefers-reduced-motion: no-preference"
        }
    }
    @MainActor func css(for contrast: Contrast, using theme: Theme) -> String {
        switch contrast {
        case .custom: "prefers-contrast: custom"
        case .high: "prefers-contrast: more"
        case .low: "prefers-contrast: less"
        case .noPreference: "prefers-contrast: no-preference"
        }
    }

    @MainActor func css(for transparency: Transparency, using theme: Theme) -> String {
        switch transparency {
        case .reduced: "prefers-reduced-transparency: reduce"
        case .normal: "prefers-reduced-transparency: no-preference"
        }
    }

    @MainActor func css(for orientation: Orientation, using theme: Theme) -> String {
        switch orientation {
        case .portrait: "orientation: portrait"
        case .landscape: "orientation: landscape"
        }
    }

    @MainActor func css(for mode: DisplayMode, using theme: Theme) -> String {
        switch mode {
        case .browser: "display-mode: browser"
        case .fullscreen: "display-mode: fullscreen"
        case .minimalUI: "display-mode: minimal-ui"
        case .pip: "display-mode: picture-in-picture"
        case .standalone: "display-mode: standalone"
        case .windowControlsOverlay: "display-mode: window-controls-overlay"
        }
    }

    @MainActor func css(for breakpoint: Breakpoint, using theme: Theme) -> String {
        let breakpointValue = switch breakpoint {
        case .small: theme.smallBreakpoint.stringValue
        case .medium: theme.mediumBreakpoint.stringValue
        case .large: theme.largeBreakpoint.stringValue
        case .xLarge: theme.xLargeBreakpoint.stringValue
        case .xxLarge: theme.xxLargeBreakpoint.stringValue
        }

        return "min-width: \(breakpointValue)"
    }
}
