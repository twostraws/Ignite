//
// HighlighterTheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Represents different syntax highlighting themes available for code blocks
public enum HighlighterTheme: CustomStringConvertible, Hashable, Sendable {
    case githubLight
    case githubDark
    case highlightJS
    case monokai
    case solarizedLight
    case solarizedDark
    case tomorrowNight
    case twilight
    case xcodeLight
    case xcodeDark
    case none
    case custom(name: String, filePath: String)

    public static var automatic: HighlighterTheme { .xcodeLight }

    var url: String {
        switch self {
        case .xcodeDark:
            return "css/highlightjs-xcode-dark.min.css"
        case .highlightJS:
            return "css/highlightjs-default.min.css"
        case .githubLight:
            return "css/highlightjs-github-light.min.css"
        case .githubDark:
            return "css/highlightjs-github-dark.min.css"
        case .xcodeLight:
            return "css/highlightjs-xcode-light.min.css"
        case .monokai:
            return "css/highlightjs-monokai.min.css"
        case .solarizedLight:
            return "css/highlightjs-solarized-light.min.css"
        case .solarizedDark:
            return "css/highlightjs-solarized-dark.min.css"
        case .tomorrowNight:
            return "css/highlightjs-tomorrow-night-bright.min.css"
        case .twilight:
            return "css/highlightjs-twilight.min.css"
        case .custom(_, let filePath):
            return filePath
        case .none:
            return ""
        }
    }

    /// The string representation of the theme
    public var description: String {
        switch self {
        case .xcodeLight, .automatic: "xcode-light"
        case .githubLight: "github-light"
        case .githubDark: "github-dark"
        case .highlightJS: "highlight-JS"
        case .monokai: "monokai"
        case .solarizedLight: "solarized-light"
        case .solarizedDark: "solarized-dark"
        case .tomorrowNight: "tomorrow-night"
        case .twilight: "twilight"
        case .xcodeDark: "xcode-dark"
        case .custom(let name, _): name
        default: "none"
        }
    }
}
