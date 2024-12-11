//
// HighlighterTheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public enum HighlighterTheme: String, Sendable {
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
        }
    }
}
