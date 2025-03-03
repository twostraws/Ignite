//
// Bootstrap-Light.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

// swiftlint:disable nesting
extension Bootstrap {
    enum Light {
        enum SemanticColors {
            static let success: Color = .init(hex: "#198754")
            static let info: Color = .init(hex: "#0dcaf0")
            static let warning: Color = .init(hex: "#ffc107")
            static let danger: Color = .init(hex: "#dc3545")
        }

        enum TextColors {
            static let primary: Color = .init(hex: "#212529")
            static let secondary: Color = .init(red: 33, green: 37, blue: 41, opacity: 0.75)
            static let tertiary: Color = .init(red: 33, green: 37, blue: 41, opacity: 0.5)
            static let emphasis: Color = .init(hex: "#212529")
        }

        enum BackgroundColors {
            static let primary: Color = .init(hex: "#ffffff")
            static let secondary: Color = .init(hex: "#e9ecef")
            static let tertiary: Color = .init(hex: "#f8f9fa")
        }

        enum ThemeColors {
            static let accent: Color = .init(hex: "#0d6efd")
            static let secondaryAccent: Color = .init(hex: "#6c757d")
            static let light: Color = .init(hex: "#f8f9fa")
            static let dark: Color = .init(hex: "#212529")
            static let border: Color = .init(hex: "#dee2e6")
        }

        enum Link {
            static let normal: Color = .init(hex: "#0d6efd")
            static let hover: Color = .init(hex: "#0a58ca")
        }
    }
}
// swiftlint:enable nesting
