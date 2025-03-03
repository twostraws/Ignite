//
// Bootstrap-Dark.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension Bootstrap {
    enum Dark {
        enum SemanticColors {
            static let success: Color = .init(hex: "#75b798")
            static let info: Color = .init(hex: "#6edff6")
            static let warning: Color = .init(hex: "#ffda6a")
            static let danger: Color = .init(hex: "#ea868f")
        }

        enum TextColors {
            static let primary: Color = .init(hex: "#dee2e6")
            static let secondary: Color = .init(red: 222, green: 226, blue: 230, opacity: 0.75)
            static let tertiary: Color = .init(red: 222, green: 226, blue: 230, opacity: 0.5)
            static let emphasis: Color = .init(hex: "#ffffff")
        }

        enum BackgroundColors {
            static let primary: Color = .init(hex: "#212529")
            static let secondary: Color = .init(hex: "#343a40")
            static let tertiary: Color = .init(hex: "#2b3035")
        }

        enum ThemeColors {
            static let accent: Color = .init(hex: "#0d6efd")
            static let secondaryAccent: Color = .init(hex: "#6c757d")
            static let light: Color = .init(hex: "#f8f9fa")
            static let dark: Color = .init(hex: "#212529")
            static let border: Color = .init(hex: "#495057")
        }

        enum Link {
            static let normal: Color = .init(hex: "#6ea8fe")
            static let hover: Color = .init(hex: "#8bb9fe")
        }
    }
}
