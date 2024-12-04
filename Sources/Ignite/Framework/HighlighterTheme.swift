//
// HighlighterTheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public enum HighlighterTheme: String, Sendable {
    case automatic
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

    var url: String {
        switch self {
        case .xcodeDark:
            return "css/highlightjs-xcode-dark.min.css"
        case .highlightJS:
            return "css/highlightjs-default.min.css"
        case .githubLight:
            return "css/highlightjs-github-light.min.css"
        case .githubDark:
            return "css/highlightjs-github-light.min.css"
        case .xcodeLight, .automatic:
            return "css/xcode-light.min.css"
        case .monokai:
            return "css/monokai.min.css"
        case .solarizedLight:
            return "css/solarized.min.css"
        case .solarizedDark:
            return "css/solarized-dark.min.css"
        case .tomorrowNight:
            return "css/tomorrow-night-bright.min.css"
        case .twilight:
            return "css/twilight.min.css"
        }
    }
}
