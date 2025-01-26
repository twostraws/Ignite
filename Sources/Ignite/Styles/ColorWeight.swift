//
// ColorWeight.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Constants that define the weight (lightness or darkness) of a color.
public enum ColorWeight: Int {
    /// 100: Extremely light variant, mixed with 80% white
    case lightest = 100

    /// 200: Very light variant, mixed with 60% white
    case lighter = 200

    /// 300: Light variant, mixed with 40% white
    case light = 300

    /// 400: Slightly light variant, mixed with 20% white
    case semiLight = 400

    /// 500: Base color with no mixing
    case regular = 500

    /// 600: Slightly dark variant, mixed with 20% black
    case semiDark = 600

    /// 700: Dark variant, mixed with 40% black
    case dark = 700

    /// 800: Very dark variant, mixed with 60% black
    case darker = 800

    /// 900: Extremely dark variant, mixed with 80% black
    case darkest = 900

    /// The percentage of white or black to mix with the base color.
    var mixPercentage: Int {
        switch self {
        case .lightest: 80
        case .lighter: 60
        case .light: 40
        case .semiLight: 20
        case .regular: 0
        case .semiDark: 20
        case .dark: 40
        case .darker: 60
        case .darkest: 80
        }
    }

    /// Indicates whether to mix with white (true) or black (false).
    var mixWithWhite: Bool {
        rawValue < 500
    }
}
