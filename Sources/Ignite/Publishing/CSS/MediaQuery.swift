//
// MediaQuery.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Represents a CSS media query with nested declarations
struct MediaQuery: CustomStringConvertible {
    enum ColorScheme: String {
        case dark = "prefers-color-scheme: dark"
        case light = "prefers-color-scheme: light"
    }

    enum Motion: String {
        case reduced = "prefers-reduced-motion: reduce"
        case allowed = "prefers-reduced-motion: no-preference"
    }

    enum Contrast: String {
        case normal = "prefers-contrast: no-preference"
        case high = "prefers-contrast: more"
        case low = "prefers-contrast: less"
    }

    enum Transparency: String {
        case reduced = "prefers-reduced-transparency: reduce"
        case normal = "prefers-reduced-transparency: no-preference"
    }

    enum Orientation: String {
        case portrait = "orientation: portrait"
        case landscape = "orientation: landscape"
    }

    enum DisplayMode: String {
        case browser = "display-mode: browser"
        case fullscreen = "display-mode: fullscreen"
        case minimalUI = "display-mode: minimal-ui"
        case pip = "display-mode: picture-in-picture"
        case standalone = "display-mode: standalone"
        case windowControlsOverlay = "display-mode: window-controls-overlay"
    }

    enum MediaFeature {
        case breakpoint(LengthUnit)
        case colorScheme(ColorScheme)
        case motion(Motion)
        case contrast(Contrast)
        case transparency(Transparency)
        case orientation(Orientation)
        case displayMode(DisplayMode)

        var description: String {
            switch self {
            case .breakpoint(let minWidth):
                "min-width: \(minWidth)"
            case .colorScheme(let scheme):
                scheme.rawValue
            case .motion(let motion):
                motion.rawValue
            case .contrast(let contrast):
                contrast.rawValue
            case .transparency(let transparency):
                transparency.rawValue
            case .orientation(let orientation):
                orientation.rawValue
            case .displayMode(let mode):
                mode.rawValue
            }
        }
    }

    enum Combinator: String {
        case and = ") and ("
        case or = ") or (" // swiftlint:disable:this identifier_name
    }

    /// The media features to check
    var features: [MediaFeature]

    /// How the features should be combined
    var combinator: Combinator

    /// The nested rulesets within this media query
    var rulesets: [Ruleset]

    init(
        _ features: MediaFeature...,
        combinator: Combinator = .and,
        @RulesetBuilder rulesets: () -> [Ruleset]
    ) {
        self.features = features
        self.combinator = combinator
        self.rulesets = rulesets()
    }

    func render() -> String {
        let query = features.map(\.description).joined(separator: combinator.rawValue)
        let rulesBlock = rulesets.map(\.description).joined(separator: "\n\n")

        return """
        @media (\(query)) {
            \(rulesBlock)
        }
        """
    }

    public var description: String {
        render()
    }
}
