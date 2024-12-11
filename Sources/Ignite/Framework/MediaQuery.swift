//
// MediaQuery.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public enum MediaQuery {
    case colorScheme(ColorScheme)
    case motion(Motion)
    case contrast(Contrast)
    case transparency(Transparency)
    case orientation(Orientation)
    case displayMode(DisplayMode)
    case theme(String)

    public enum ColorScheme {
        case dark
        case light
    }

    public enum Motion {
        case reduced
        case allowed
    }

    public enum Contrast {
        case reduced
        case high
        case low
    }

    public enum Transparency {
        case reduced
        case normal
    }

    public enum Orientation {
        case portrait
        case landscape
    }

    public enum DisplayMode {
        case browser
        case fullscreen
        case minimalUI
        case pip
        case standalone
        case windowControlsOverlay
    }

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
