//
// HighlighterTheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Represents different syntax highlighting themes available for code blocks
public enum HighlighterTheme: CustomStringConvertible, Hashable, Comparable, Sendable {
    case githubLight
    case githubDark
    case prism
    case okaidia
    case solarizedLight
    case solarizedDark
    case tomorrow
    case twilight
    case xcodeLight
    case xcodeDark
    case none
    case custom(name: String, filePath: String)

    public static var automatic: HighlighterTheme { .xcodeLight }

    var url: String {
        switch self {
        case .xcodeDark:
            return "css/prism-xcode-dark.css"
        case .prism:
            return "css/prism-default.min.css"
        case .githubLight:
            return "css/prism-github-light.css"
        case .githubDark:
            return "css/prism-github-dark.css"
        case .xcodeLight:
            return "css/prism-xcode-light.css"
        case .okaidia:
            return "css/prism-okaidia.min.css"
        case .solarizedLight:
            return "css/prism-solarized-light.min.css"
        case .solarizedDark:
            return "css/prism-solarized-dark.css"
        case .tomorrow:
            return "css/prism-tomorrow.css"
        case .twilight:
            return "css/prism-twilight.css"
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
        case .prism: "default"
        case .okaidia: "okaidia"
        case .solarizedLight: "solarized-light"
        case .solarizedDark: "solarized-dark"
        case .tomorrow: "tomorrow"
        case .twilight: "twilight"
        case .xcodeDark: "xcode-dark"
        case .custom(let name, _): name
        default: "none"
        }
    }

    public static func < (lhs: HighlighterTheme, rhs: HighlighterTheme) -> Bool {
        lhs.description < rhs.description
    }
}
