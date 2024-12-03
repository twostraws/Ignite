//
// ColorWeight.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Constants that define the weight (lightness or darkness) of a color.
public enum ColorWeight: Int {
    /// 100: Extremely light variant, mixed with 80% white
    case pale = 100
    
    /// 200: Very light variant, mixed with 60% white
    case lightest = 200
    
    /// 300: Light variant, mixed with 40% white
    case lighter = 300
    
    /// 400: Slightly light variant, mixed with 20% white
    case light = 400
    
    /// 500: Base color with no mixing
    case regular = 500
    
    /// 600: Slightly dark variant, mixed with 20% black
    case dark = 600
    
    /// 700: Dark variant, mixed with 40% black
    case darker = 700
    
    /// 800: Very dark variant, mixed with 60% black
    case darkest = 800
    
    /// 900: Extremely dark variant, mixed with 80% black
    case deep = 900
    
    /// The percentage of white or black to mix with the base color.
    var mixPercentage: Int {
        switch self {
        case .pale: return 80
        case .lightest: return 60
        case .lighter: return 40
        case .light: return 20
        case .regular: return 0
        case .dark: return 20
        case .darker: return 40
        case .darkest: return 60
        case .deep: return 80
        }
    }
    
    /// Indicates whether to mix with white (true) or black (false).
    var mixWithWhite: Bool {
        rawValue < 500
    }
}
