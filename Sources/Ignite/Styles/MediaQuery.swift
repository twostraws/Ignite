//
// MediaQuery.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that represents different media query conditions for applying conditional styles.
public enum MediaQuery {
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

    /// The user's preferred color scheme options.
    public enum ColorScheme {
        /// Dark mode preference
        case dark
        /// Light mode preference
        case light
    }

    /// The user's motion preference options.
    public enum Motion {
        /// Reduced motion preference
        case reduced
        /// Standard motion preference
        case allowed
    }

    /// The user's contrast preference options.
    public enum Contrast {
        /// Reduced contrast preference
        case reduced
        /// High contrast preference
        case high
        /// Low contrast preference
        case low
    }

    /// The user's transparency preference options.
    public enum Transparency {
        /// Reduced transparency preference
        case reduced
        /// Standard transparency preference
        case normal
    }

    /// The device orientation options.
    public enum Orientation {
        /// Portrait orientation
        case portrait
        /// Landscape orientation
        case landscape
    }

    /// The web application display mode options.
    public enum DisplayMode {
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

    /// The CSS media query string for this condition.
    var query: String {
        switch self {
        case .colorScheme(let scheme):
            switch scheme {
            case .dark: "prefers-color-scheme: dark"
            case .light: "prefers-color-scheme: light"
            }

        case .motion(let motion):
            switch motion {
            case .reduced: "prefers-reduced-motion: reduce"
            case .allowed: "prefers-reduced-motion: no-preference"
            }

        case .contrast(let contrast):
            switch contrast {
            case .reduced: "prefers-contrast: less"
            case .high: "prefers-contrast: more"
            case .low: "prefers-contrast: less"
            }

        case .transparency(let transparency):
            switch transparency {
            case .reduced: "prefers-reduced-transparency: reduce"
            case .normal: "prefers-reduced-transparency: no-preference"
            }

        case .orientation(let orientation):
            switch orientation {
            case .portrait: "orientation: portrait"
            case .landscape: "orientation: landscape"
            }

        case .displayMode(let mode):
            switch mode {
            case .browser: "display-mode: browser"
            case .fullscreen: "display-mode: fullscreen"
            case .minimalUI: "display-mode: minimal-ui"
            case .pip: "display-mode: picture-in-picture"
            case .standalone: "display-mode: standalone"
            case .windowControlsOverlay: "display-mode: window-controls-overlay"
            }

        case .theme(let id):
            "data-theme-state=\"\(id.kebabCased())\""
        }
    }
}
