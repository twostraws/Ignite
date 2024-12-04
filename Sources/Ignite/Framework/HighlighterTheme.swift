//
// HighlighterTheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public enum HighlighterTheme: String, Sendable {
    case automatic
    case highlightJS
    case github
    case xcode
    case xcodeDark
    case monokai
    case solarized
    case tomorrow
    case twilight

    var url: String {
        switch self {
        case .xcodeDark:
            return "/css/highlightjs-xcode-dark.css"
        case .highlightJS:
            return "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/default.min.css"
        case .github:
            return "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github.min.css"
        case .xcode, .automatic:
            return "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/xcode.min.css"
        case .monokai:
            return "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/monokai.min.css"
        case .solarized:
            return "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/solarized-dark.min.css"
        case .tomorrow:
            return "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/tomorrow-night.min.css"
        case .twilight:
            return "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/twilight.min.css"
        }
    }
}
