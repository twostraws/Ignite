//
// Color.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Colors that can be used for backgrounds and foregrounds. Comes with all
/// the standard HTML color names, can be created using RGB values as
/// integer or doubles, can be created a grayscale, or using a hex string.
public enum Color: CustomStringConvertible, Sendable, Hashable {
    case bootstrap(name: String, hex: String, opacity: Double)
    case html(red: Int, green: Int, blue: Int, opacity: Double)

    /// Bootstrap's primary blue color (#0d6efd)
    public static let blue = Color(hex: "#0d6efd", name: "blue")

    /// Bootstrap's indigo color (#6610f2)
    public static let indigo = Color(hex: "#6610f2", name: "indigo")

    /// Bootstrap's purple color (#6f42c1)
    public static let purple = Color(hex: "#6f42c1", name: "purple")

    /// Bootstrap's pink color (#d63384)
    public static let pink = Color(hex: "#d63384", name: "pink")

    /// Bootstrap's red color (#dc3545)
    public static let red = Color(hex: "#dc3545", name: "red")

    /// Bootstrap's orange color (#fd7e14)
    public static let orange = Color(hex: "#fd7e14", name: "orange")

    /// Bootstrap's yellow color (#ffc107)
    public static let yellow = Color(hex: "#ffc107", name: "yellow")

    /// Bootstrap's green color (#198754)
    public static let green = Color(hex: "#198754", name: "green")

    /// Bootstrap's teal color (#20c997)
    public static let teal = Color(hex: "#20c997", name: "teal")

    /// Bootstrap's cyan color (#0dcaf0)
    public static let cyan = Color(hex: "#0dcaf0", name: "cyan")

    /// Bootstrap's gray color (#adb5bd)
    public static let gray = Color(hex: "#adb5bd", name: "gray")

    /// The HTML color name "black" (#000000)
    public static let black = Color(hex: "#000000", name: "black")

    /// The HTML color name "white" (#FFFFFF)
    public static let white = Color(hex: "#FFFFFF", name: "white")

    /// A structure that holds the RGB and opacity components of a color.
    fileprivate struct RGBComponents {
        /// The red component, in the range 0 through 255.
        var red: Int
        /// The green component, in the range 0 through 255.
        var green: Int
        /// The blue component, in the range 0 through 255.
        var blue: Int
        /// The opacity component, in the range 0 through 1.
        var opacity: Double
    }

    /// The CSS representation of this color.
    public var description: String {
        switch self {
        case .bootstrap(let name, let hex, let opacity):
            if opacity == 1 {
                return "var(--bs-\(name))"
            } else {
                let components = Self.parseHexColor(hex)
                return Self.rgbToHex(
                    red: components.red,
                    green: components.green,
                    blue: components.blue,
                    opacity: opacity
                )
            }
        case .html(let red, let green, let blue, let opacity):
            return opacity == 1
                ? "rgb(\(red), \(green), \(blue))"
                : "rgba(\(red), \(green), \(blue), \(opacity))"
        }
    }

    private var name: String {
        switch self {
        case .bootstrap(let name, _, _):
            return name
        case .html(let red, let green, let blue, let opacity):
            return Self.rgbToHex(red: red, green: green, blue: blue, opacity: opacity)
        }
    }

    /// Creates a color from a hex string with an optional name override.
    /// - Parameters:
    ///   - hex: A string containing a hex color value (e.g., "#FF0000")
    ///   - name: Optional name for the color. If nil, uses the hex value as the name.
    private init(hex: String, name: String? = nil) {
        if let name {
            self = .bootstrap(name: name, hex: hex, opacity: 1.0)
        } else {
            let components = Self.parseHexColor(hex)
            self = .html(red: components.red, green: components.green, blue: components.blue, opacity: components.opacity)
        }
    }

    /// Creates a new color from a HTML hex color string. Must start with #, e.g.
    /// `#FFE700`.
    /// - Parameter hex: The hex string to parse. May contain 6 or 8
    ///  characters, excluding the leading #.
    public init(hex: String) {
        let components = Self.parseHexColor(hex)
        self = .html(red: components.red,
                     green: components.green,
                     blue: components.blue,
                     opacity: components.opacity)
    }

    /// Creates a new color from the specified RGB components, optionally also
    /// providing an opacity.
    /// - Parameters:
    ///   - red: How much red to use, in the range of 0 through 255.
    ///   - green: How much green to use, in the range of 0 through 255.
    ///   - blue: How much blue to use, in the range of 0 through 255.
    ///   - opacity: How opaque the color should be, in the range of 0
    ///   (transparent) through to 1 (opaque). Defaults to 1.
    public init(red: Int, green: Int, blue: Int, opacity: Double = 1) {
        self = .html(red: red, green: green, blue: blue, opacity: opacity)
    }

    /// Creates a new color from the specified RGB components, optionally also
    /// providing an opacity.
    /// - Parameters:
    ///   - red: How much red to use, in the range of 0 through 1.
    ///   - green: How much green to use, in the range of 0 through 1.
    ///   - blue: How much blue to use, in the range of 0 through 1.
    ///   - opacity: How opaque the color should be, in the range of 0
    ///   (transparent) through to 1 (opaque). Defaults to 1.
    public init(red: Double, green: Double, blue: Double, opacity: Double = 1) {
        let intRed = Int(red * 255)
        let intGreen = Int(green * 255)
        let intBlue = Int(blue * 255)
        self = .html(red: intRed, green: intGreen, blue: intBlue, opacity: opacity)
    }

    /// Creates a new grayscale color from the specified white value, optionally also
    /// providing an opacity.
    /// - Parameters:
    ///   - white: How much white to use, in the range of 0 through 1.
    ///   - opacity: How opaque the color should be, in the range of 0
    ///   (transparent) through to 1 (opaque).
    public init(white: Double, opacity: Double = 1) {
        let intWhite = Int(white * 255)
        self.init(red: intWhite, green: intWhite, blue: intWhite, opacity: opacity)
    }

    /// Multiplies the opacity of this color by the given amount.
    /// - Parameter opacity: How much to adjust the opacity by.
    /// - Returns: A new color with the opacity value taken into account. Note:
    /// because this multiplies the existing opacity, this cannot produce a color that
    /// is more opaque than the original.
    public func opacity(_ opacity: Double) -> Self {
        switch self {
        case .bootstrap(let name, let hex, let currentOpacity):
            return .bootstrap(name: name, hex: hex, opacity: currentOpacity * opacity)
        case .html(let red, let green, let blue, let currentOpacity):
            return .html(red: red, green: green, blue: blue, opacity: currentOpacity * opacity)
        }
    }

    /// Creates a weighted variant of the color by mixing it with white or black.
    /// - Parameter weight: The desired weight to apply to the color, determining how much white or black to mix.
    /// - Returns: A new `HTMLColor` instance with the weighted variant name.
    /// - Note: This function must be called from the main actor as it registers the variant with the shared `StyleManager`.
    @MainActor public func weighted(_ weight: ColorWeight) -> Self {
        let mixWithWhite = weight.mixWithWhite
        let mixColor = mixWithWhite ? Color.white : Color.black
        let percentage = Double(weight.mixPercentage) / 100.0

        // Get the RGB components of both colors
        let baseComponents: RGBComponents = {
            switch self {
            case .bootstrap(_, let hex, let opacity):
                var components = Self.parseHexColor(hex)
                components.opacity = opacity
                return components
            case .html(let r, let g, let b, let opacity):
                return RGBComponents(red: r, green: g, blue: b, opacity: opacity)
            }
        }()

        let mixComponents = switch mixColor {
        case .bootstrap(_, let hex, _):
            Self.parseHexColor(hex)
        case .html(let r, let g, let b, _):
            RGBComponents(red: r, green: g, blue: b, opacity: 1)
        }

        let mixedComponents = Self.mix(
            baseComponents,
            with: mixComponents,
            weight: percentage
        )

        return createHTMLColor(from: mixedComponents)
    }

    private func createHTMLColor(from components: RGBComponents) -> Self {
        return .html(
            red: components.red,
            green: components.green,
            blue: components.blue,
            opacity: components.opacity
        )
    }

    /// Parses a hexadecimal color string into its RGB components.
    /// - Parameter hex: A string containing a hex color value (e.g., "#FF0000" or "#FF0000FF").
    /// - Returns: An `RGBComponents` instance containing the parsed color values.
    private static func parseHexColor(_ hex: String) -> RGBComponents {
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    return RGBComponents(
                        red: Int((hexNumber & 0xff000000) >> 24),
                        green: Int((hexNumber & 0x00ff0000) >> 16),
                        blue: Int((hexNumber & 0x0000ff00) >> 8),
                        opacity: Double(hexNumber & 0x000000ff) / 255.0
                    )
                }
            } else if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    return RGBComponents(
                        red: Int((hexNumber & 0xff0000) >> 16),
                        green: Int((hexNumber & 0x00ff00) >> 8),
                        blue: Int(hexNumber & 0x0000ff),
                        opacity: 1
                    )
                }
            }
        }

        return RGBComponents(red: 0, green: 0, blue: 0, opacity: 1)
    }

    /// Converts RGB and opacity values to a hex color string
    /// - Parameters:
    ///   - red: Red component (0-255)
    ///   - green: Green component (0-255)
    ///   - blue: Blue component (0-255)
    ///   - opacity: Opacity value (0-1)
    /// - Returns: A hex color string in the format "#RRGGBB" or "#RRGGBBAA"
    private static func rgbToHex(red: Int, green: Int, blue: Int, opacity: Double) -> String {
        let r = String(format: "%02X", red)
        let g = String(format: "%02X", green)
        let b = String(format: "%02X", blue)

        if opacity == 1 {
            return "#\(r)\(g)\(b)"
        } else {
            let a = String(format: "%02X", Int(opacity * 255))
            return "#\(r)\(g)\(b)\(a)"
        }
    }
}

public extension Color {
    /// Creates a color from a hexadecimal integer (e.g., 0xFF0000 for red)
    /// - Parameter hex: An integer containing a hex color value
    init(_ hex: Int) {
        let red = (hex >> 16) & 0xff
        let green = (hex >> 8) & 0xff
        let blue = hex & 0xff
        self = .html(red: red, green: green, blue: blue, opacity: 1.0)
    }

    /// Creates a color from a hexadecimal integer with opacity
    /// - Parameters:
    ///   - hex: An integer containing a hex color value
    ///   - opacity: The opacity value between 0 and 1
    init(hex: Int, opacity: Double) {
        let red = (hex >> 16) & 0xff
        let green = (hex >> 8) & 0xff
        let blue = hex & 0xff
        self = .html(red: red, green: green, blue: blue, opacity: opacity)
    }

    /// Mixes two colors using the same algorithm as Sass's mix() function
    /// - Parameters:
    ///   - color1: The base color components
    ///   - color2: The color to mix with
    ///   - weight: Weight of the second color (0-1), where 0 gives full color1 and 1 gives full color2
    /// - Returns: The mixed color components
    private static func mix(_ color1: RGBComponents, with color2: RGBComponents, weight: Double) -> RGBComponents {
        let w = weight * 2 - 1
        let a = 0.0

        let numerator = w + a
        let denominator = 1 + (w * a)
        let fraction = numerator / denominator
        let w1 = (w * a == -1 ? w : fraction + 1) / 2
        let w2 = 1 - w1

        // Break down RGB calculations
        let red1 = Double(color1.red) * w2
        let red2 = Double(color2.red) * w1
        let red = Int(round(red1 + red2))

        let green1 = Double(color1.green) * w2
        let green2 = Double(color2.green) * w1
        let green = Int(round(green1 + green2))

        let blue1 = Double(color1.blue) * w2
        let blue2 = Double(color2.blue) * w1
        let blue = Int(round(blue1 + blue2))

        return RGBComponents(
            red: red,
            green: green,
            blue: blue,
            opacity: color1.opacity
        )
    }
}
