//
// Color.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

// swiftlint:disable file_length
// There are lots of HTML color names here!

/// Colors that can be used for backgrounds and foregrounds. Comes with all
/// the standard HTML color names, can be created using RGB values as
/// integer or doubles, can be created a grayscale, or using a hex string.
public struct Color: CustomStringConvertible {
    /// The CSS representation of this color.
    public var description: String {
        "rgb(\(red) \(green) \(blue) / \(opacity)%)"
    }

    /// The HTML color name "aliceblue" (#F0F8FF)
    public static let aliceBlue = Color(hex: "#F0F8FF")

    /// The HTML color name "antiquewhite" (#FAEBD7)
    public static let antiqueWhite = Color(hex: "#FAEBD7")

    /// The HTML color name "aqua" (#00FFFF)
    public static let aqua = Color(hex: "#00FFFF")

    /// The HTML color name "aquamarine" (#7FFFD4)
    public static let aquamarine = Color(hex: "#7FFFD4")

    /// The HTML color name "azure" (#F0FFFF)
    public static let azure = Color(hex: "#F0FFFF")

    /// The HTML color name "beige" (#F5F5DC)
    public static let beige = Color(hex: "#F5F5DC")

    /// The HTML color name "bisque" (#FFE4C4)
    public static let bisque = Color(hex: "#FFE4C4")

    /// The HTML color name "black" (#000000)
    public static let black = Color(hex: "#000000")

    /// The HTML color name "blanchedalmond" (#FFEBCD)
    public static let blanchedAlmond = Color(hex: "#FFEBCD")

    /// The HTML color name "blue" (#0000FF)
    public static let blue = Color(hex: "#0000FF")

    /// The HTML color name "blueviolet" (#8A2BE2)
    public static let blueViolet = Color(hex: "#8A2BE2")

    /// The HTML color name "brown" (#A52A2A)
    public static let brown = Color(hex: "#A52A2A")

    /// The HTML color name "burlywood" (#DEB887)
    public static let burlyWood = Color(hex: "#DEB887")

    /// The HTML color name "cadetblue" (#5F9EA0)
    public static let cadetBlue = Color(hex: "#5F9EA0")

    /// The HTML color name "chartreuse" (#7FFF00)
    public static let chartreuse = Color(hex: "#7FFF00")

    /// The HTML color name "chocolate" (#D2691E)
    public static let chocolate = Color(hex: "#D2691E")

    /// The HTML color name "coral" (#FF7F50)
    public static let coral = Color(hex: "#FF7F50")

    /// The HTML color name "cornflowerblue" (#6495ED)
    public static let cornflowerBlue = Color(hex: "#6495ED")

    /// The HTML color name "cornsilk" (#FFF8DC)
    public static let cornsilk = Color(hex: "#FFF8DC")

    /// The HTML color name "crimson" (#DC143C)
    public static let crimson = Color(hex: "#DC143C")

    /// The HTML color name "cyan" (#00FFFF)
    public static let cyan = Color(hex: "#00FFFF")

    /// The HTML color name "darkblue" (#00008B)
    public static let darkBlue = Color(hex: "#00008B")

    /// The HTML color name "darkcyan" (#008B8B)
    public static let darkCyan = Color(hex: "#008B8B")

    /// The HTML color name "darkgoldenrod" (#B8860B)
    public static let darkGoldenrod = Color(hex: "#B8860B")

    /// The HTML color name "darkgray" (#A9A9A9)
    public static let darkGray = Color(hex: "#A9A9A9")

    /// The HTML color name "darkgrey" (#A9A9A9)
    public static let darkGrey = Color(hex: "#A9A9A9")

    /// The HTML color name "darkgreen" (#006400)
    public static let darkGreen = Color(hex: "#006400")

    /// The HTML color name "darkkhaki" (#BDB76B)
    public static let darkKhaki = Color(hex: "#BDB76B")

    /// The HTML color name "darkmagenta" (#8B008B)
    public static let darkMagenta = Color(hex: "#8B008B")

    /// The HTML color name "darkolivegreen" (#556B2F)
    public static let darkOliveGreen = Color(hex: "#556B2F")

    /// The HTML color name "darkorange" (#FF8C00)
    public static let darkOrange = Color(hex: "#FF8C00")

    /// The HTML color name "darkorchid" (#9932CC)
    public static let darkOrchid = Color(hex: "#9932CC")

    /// The HTML color name "darkred" (#8B0000)
    public static let darkRed = Color(hex: "#8B0000")

    /// The HTML color name "darksalmon" (#E9967A)
    public static let darkSalmon = Color(hex: "#E9967A")

    /// The HTML color name "darkseagreen" (#8FBC8F)
    public static let darkSeaGreen = Color(hex: "#8FBC8F")

    /// The HTML color name "darkslateblue" (#483D8B)
    public static let darkSlateBlue = Color(hex: "#483D8B")

    /// The HTML color name "darkslategray" (#2F4F4F)
    public static let darkSlateGray = Color(hex: "#2F4F4F")

    /// The HTML color name "darkslategrey" (#2F4F4F)
    public static let darkSlateGrey = Color(hex: "#2F4F4F")

    /// The HTML color name "darkturquoise" (#00CED1)
    public static let darkTurquoise = Color(hex: "#00CED1")

    /// The HTML color name "darkviolet" (#9400D3)
    public static let darkViolet = Color(hex: "#9400D3")

    /// The HTML color name "deeppink" (#FF1493)
    public static let deepPink = Color(hex: "#FF1493")

    /// The HTML color name "deepskyblue" (#00BFFF)
    public static let deepSkyBlue = Color(hex: "#00BFFF")

    /// The HTML color name "dimgray" (#696969)
    public static let dimGray = Color(hex: "#696969")

    /// The HTML color name "dimgrey" (#696969)
    public static let dimGrey = Color(hex: "#696969")

    /// The HTML color name "dodgerblue" (#1E90FF)
    public static let dodgerBlue = Color(hex: "#1E90FF")

    /// The HTML color name "firebrick" (#B22222)
    public static let firebrick = Color(hex: "#B22222")

    /// The HTML color name "floralwhite" (#FFFAF0)
    public static let floralWhite = Color(hex: "#FFFAF0")

    /// The HTML color name "forestgreen" (#228B22)
    public static let forestGreen = Color(hex: "#228B22")

    /// The HTML color name "fuchsia" (#FF00FF)
    public static let fuchsia = Color(hex: "#FF00FF")

    /// The HTML color name "gainsboro" (#DCDCDC)
    public static let gainsboro = Color(hex: "#DCDCDC")

    /// The HTML color name "ghostwhite" (#F8F8FF)
    public static let ghostWhite = Color(hex: "#F8F8FF")

    /// The HTML color name "gold" (#FFD700)
    public static let gold = Color(hex: "#FFD700")

    /// The HTML color name "goldenrod" (#DAA520)
    public static let goldenrod = Color(hex: "#DAA520")

    /// The HTML color name "gray" (#808080)
    public static let gray = Color(hex: "#808080")

    /// The HTML color name "grey" (#808080)
    public static let grey = Color(hex: "#808080")

    /// The HTML color name "green" (#008000)
    public static let green = Color(hex: "#008000")

    /// The HTML color name "greenyellow" (#ADFF2F)
    public static let greenYellow = Color(hex: "#ADFF2F")

    /// The HTML color name "honeydew" (#F0FFF0)
    public static let honeydew = Color(hex: "#F0FFF0")

    /// The HTML color name "hotpink" (#FF69B4)
    public static let hotPink = Color(hex: "#FF69B4")

    /// The HTML color name "hudsonyellow" (#FFE700)
    public static let hudsonYellow = Color(hex: "#FFE700")

    /// The HTML color name "indianred" (#CD5C5C)
    public static let indianRed = Color(hex: "#CD5C5C")

    /// The HTML color name "indigo" (#4B0082)
    public static let indigo = Color(hex: "#4B0082")

    /// The HTML color name "ivory" (#FFFFF0)
    public static let ivory = Color(hex: "#FFFFF0")

    /// The HTML color name "khaki" (#F0E68C)
    public static let khaki = Color(hex: "#F0E68C")

    /// The HTML color name "lavender" (#E6E6FA)
    public static let lavender = Color(hex: "#E6E6FA")

    /// The HTML color name "lavenderblush" (#FFF0F5)
    public static let lavenderBlush = Color(hex: "#FFF0F5")

    /// The HTML color name "lawngreen" (#7CFC00)
    public static let lawnGreen = Color(hex: "#7CFC00")

    /// The HTML color name "lemonchiffon" (#FFFACD)
    public static let lemonChiffon = Color(hex: "#FFFACD")

    /// The HTML color name "lightblue" (#ADD8E6)
    public static let lightBlue = Color(hex: "#ADD8E6")

    /// The HTML color name "lightcoral" (#F08080)
    public static let lightCoral = Color(hex: "#F08080")

    /// The HTML color name "lightcyan" (#E0FFFF)
    public static let lightCyan = Color(hex: "#E0FFFF")

    /// The HTML color name "lightgoldenrodyellow" (#FAFAD2)
    public static let lightGoldenrodYellow = Color(hex: "#FAFAD2")

    /// The HTML color name "lightgray" (#D3D3D3)
    public static let lightGray = Color(hex: "#D3D3D3")

    /// The HTML color name "lightgrey" (#D3D3D3)
    public static let lightGrey = Color(hex: "#D3D3D3")

    /// The HTML color name "lightgreen" (#90EE90)
    public static let lightGreen = Color(hex: "#90EE90")

    /// The HTML color name "lightpink" (#FFB6C1)
    public static let lightPink = Color(hex: "#FFB6C1")

    /// The HTML color name "lightsalmon" (#FFA07A)
    public static let lightSalmon = Color(hex: "#FFA07A")

    /// The HTML color name "lightseagreen" (#20B2AA)
    public static let lightSeaGreen = Color(hex: "#20B2AA")

    /// The HTML color name "lightskyblue" (#87CEFA)
    public static let lightSkyBlue = Color(hex: "#87CEFA")

    /// The HTML color name "lightslategray" (#778899)
    public static let lightSlateGray = Color(hex: "#778899")

    /// The HTML color name "lightslategrey" (#778899)
    public static let lightSlateGrey = Color(hex: "#778899")

    /// The HTML color name "lightsteelblue" (#B0C4DE)
    public static let lightSteelBlue = Color(hex: "#B0C4DE")

    /// The HTML color name "lightyellow" (#FFFFE0)
    public static let lightYellow = Color(hex: "#FFFFE0")

    /// The HTML color name "lime" (#00FF00)
    public static let lime = Color(hex: "#00FF00")

    /// The HTML color name "limegreen" (#32CD32)
    public static let limeGreen = Color(hex: "#32CD32")

    /// The HTML color name "linen" (#FAF0E6)
    public static let linen = Color(hex: "#FAF0E6")

    /// The HTML color name "magenta" (#FF00FF)
    public static let magenta = Color(hex: "#FF00FF")

    /// The HTML color name "maroon" (#800000)
    public static let maroon = Color(hex: "#800000")

    /// The HTML color name "mediumaquamarine" (#66CDAA)
    public static let mediumAquamarine = Color(hex: "#66CDAA")

    /// The HTML color name "mediumblue" (#0000CD)
    public static let mediumBlue = Color(hex: "#0000CD")

    /// The HTML color name "mediumorchid" (#BA55D3)
    public static let mediumOrchid = Color(hex: "#BA55D3")

    /// The HTML color name "mediumpurple" (#9370D8)
    public static let mediumPurple = Color(hex: "#9370D8")

    /// The HTML color name "mediumseagreen" (#3CB371)
    public static let mediumSeaGreen = Color(hex: "#3CB371")

    /// The HTML color name "mediumslateblue" (#7B68EE)
    public static let mediumSlateBlue = Color(hex: "#7B68EE")

    /// The HTML color name "mediumspringgreen" (#00FA9A)
    public static let mediumSpringGreen = Color(hex: "#00FA9A")

    /// The HTML color name "mediumturquoise" (#48D1CC)
    public static let mediumTurquoise = Color(hex: "#48D1CC")

    /// The HTML color name "mediumvioletred" (#C71585)
    public static let mediumVioletRed = Color(hex: "#C71585")

    /// The HTML color name "midnightblue" (#191970)
    public static let midnightBlue = Color(hex: "#191970")

    /// The HTML color name "mintcream" (#F5FFFA)
    public static let mintCream = Color(hex: "#F5FFFA")

    /// The HTML color name "mistyrose" (#FFE4E1)
    public static let mistyRose = Color(hex: "#FFE4E1")

    /// The HTML color name "moccasin" (#FFE4B5)
    public static let moccasin = Color(hex: "#FFE4B5")

    /// The HTML color name "navajowhite" (#FFDEAD)
    public static let navajoWhite = Color(hex: "#FFDEAD")

    /// The HTML color name "navy" (#000080)
    public static let navy = Color(hex: "#000080")

    /// The HTML color name "oldlace" (#FDF5E6)
    public static let oldLace = Color(hex: "#FDF5E6")

    /// The HTML color name "olive" (#808000)
    public static let olive = Color(hex: "#808000")

    /// The HTML color name "olivedrab" (#6B8E23)
    public static let oliveDrab = Color(hex: "#6B8E23")

    /// The HTML color name "orange" (#FFA500)
    public static let orange = Color(hex: "#FFA500")

    /// The HTML color name "orangered" (#FF4500)
    public static let orangeRed = Color(hex: "#FF4500")

    /// The HTML color name "orchid" (#DA70D6)
    public static let orchid = Color(hex: "#DA70D6")

    /// The HTML color name "palegoldenrod" (#EEE8AA)
    public static let paleGoldenRod = Color(hex: "#EEE8AA")

    /// The HTML color name "palegreen" (#98FB98)
    public static let paleGreen = Color(hex: "#98FB98")

    /// The HTML color name "paleturquoise" (#AFEEEE)
    public static let paleTurquoise = Color(hex: "#AFEEEE")

    /// The HTML color name "palevioletred" (#D87093)
    public static let paleVioletRed = Color(hex: "#D87093")

    /// The HTML color name "papayawhip" (#FFEFD5)
    public static let papayaWhip = Color(hex: "#FFEFD5")

    /// The HTML color name "peachpu" (#FFDAB9)
    public static let peachpu = Color(hex: "#FFDAB9")

    /// The HTML color name "peru" (#CD853F)
    public static let peru = Color(hex: "#CD853F")

    /// The HTML color name "pink" (#FFC0CB)
    public static let pink = Color(hex: "#FFC0CB")

    /// The HTML color name "plum" (#DDA0DD)
    public static let plum = Color(hex: "#DDA0DD")

    /// The HTML color name "powderblue" (#B0E0E6)
    public static let powderBlue = Color(hex: "#B0E0E6")

    /// The HTML color name "purple" (#800080)
    public static let purple = Color(hex: "#800080")

    /// The HTML color name "rebeccapurple" (#663399)
    public static let rebeccaPurple = Color(hex: "#663399")

    /// The HTML color name "red" (#FF0000)
    public static let red = Color(hex: "#FF0000")

    /// The HTML color name "rosybrown" (#BC8F8F)
    public static let rosyBrown = Color(hex: "#BC8F8F")

    /// The HTML color name "royalblue" (#4169E1)
    public static let royalBlue = Color(hex: "#4169E1")

    /// The HTML color name "saddlebrown" (#8B4513)
    public static let saddleBrown = Color(hex: "#8B4513")

    /// The HTML color name "salmon" (#FA8072)
    public static let salmon = Color(hex: "#FA8072")

    /// The HTML color name "sandybrown" (#F4A460)
    public static let sandyBrown = Color(hex: "#F4A460")

    /// The HTML color name "seagreen" (#2E8B57)
    public static let seaGreen = Color(hex: "#2E8B57")

    /// The HTML color name "seashell" (#FFF5EE)
    public static let seashell = Color(hex: "#FFF5EE")

    /// The HTML color name "sienna" (#A0522D)
    public static let sienna = Color(hex: "#A0522D")

    /// The HTML color name "silver" (#C0C0C0)
    public static let silver = Color(hex: "#C0C0C0")

    /// The HTML color name "skyblue" (#87CEEB)
    public static let skyBlue = Color(hex: "#87CEEB")

    /// The HTML color name "slateblue" (#6A5ACD)
    public static let slateBlue = Color(hex: "#6A5ACD")

    /// The HTML color name "slategray" (#708090)
    public static let slateGray = Color(hex: "#708090")

    /// The HTML color name "slategrey" (#708090)
    public static let slateGrey = Color(hex: "#708090")

    /// The HTML color name "snow" (#FFFAFA)
    public static let snow = Color(hex: "#FFFAFA")

    /// The HTML color name "springgreen" (#00FF7F)
    public static let springGreen = Color(hex: "#00FF7F")

    /// The HTML color name "steelblue" (#4682B4)
    public static let steelBlue = Color(hex: "#4682B4")

    /// The HTML color name "tan" (#D2B48C)
    public static let tan = Color(hex: "#D2B48C")

    /// The HTML color name "teal" (#008080)
    public static let teal = Color(hex: "#008080")

    /// The HTML color name "thistle" (#D8BFD8)
    public static let thistle = Color(hex: "#D8BFD8")

    /// The HTML color name "tomato" (#FF6347)
    public static let tomato = Color(hex: "#FF6347")

    /// The HTML color name "turquoise" (#40E0D0)
    public static let turquoise = Color(hex: "#40E0D0")

    /// The HTML color name "violet" (#EE82EE)
    public static let violet = Color(hex: "#EE82EE")

    /// The HTML color name "wheat" (#F5DEB3)
    public static let wheat = Color(hex: "#F5DEB3")

    /// The HTML color name "white" (#FFFFFF)
    public static let white = Color(hex: "#FFFFFF")

    /// The HTML color name "whitesmoke" (#F5F5F5)
    public static let whiteSmoke = Color(hex: "#F5F5F5")

    /// The HTML color name "yellow" (#FFFF00)
    public static let yellow = Color(hex: "#FFFF00")

    /// The HTML color name "yellowgreen" (#9ACD32)
    public static let yellowGreen = Color(hex: "#9ACD32")

    /// The red component for this color, in the range 0 through 255.
    public var red: Int

    /// The green component for this color, in the range 0 through 255.
    public var green: Int

    /// The blue component for this color, in the range 0 through 255.
    public var blue: Int

    /// The opacity component for this color, in the range 0 (transparent) through 100 (opaque).
    public var opacity: Int

    /// Creates a new color from the specified RGB components, optionally also
    /// providing an opacity.
    /// - Parameters:
    ///   - red: How much red to use, in the range of 0 through 255.
    ///   - green: How much green to use, in the range of 0 through 255.
    ///   - blue: How much blue to use, in the range of 0 through 255.
    ///   - opacity: How opaque the color should be, in the range of 0
    ///   (transparent) through to 100 (opaque). Defaults to 100,
    public init(red: Int, green: Int, blue: Int, opacity: Int = 100) {
        self.red = red
        self.green = green
        self.blue = blue
        self.opacity = opacity
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
        let intOpacity = Int(opacity * 255)

        self.init(red: intRed, green: intGreen, blue: intBlue, opacity: intOpacity)
    }

    /// Creates a new grayscale color from the specified white value, optionally also
    /// providing an opacity.
    /// - Parameters:
    ///   - white: How much white to use, in the range of 0 through 1.
    ///   - opacity: How opaque the color should be, in the range of 0
    ///   (transparent) through to 1 (opaque).
    public init(white: Double, opacity: Double = 1) {
        let intWhite = Int(white * 255)
        let intOpacity = Int(opacity * 255)

        self.init(red: intWhite, green: intWhite, blue: intWhite, opacity: intOpacity)
    }

    /// Creates a new color from a HTML hex color string. Must start with #, e.g.
    /// `#FFE700`.
    /// - Parameter hex: The hex string to parse. May contain 6 or 8
    ///  characters, excluding the leading #.
    public init(hex: String) {
        let red, green, blue, alpha: Int

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    red = Int((hexNumber & 0xff000000) >> 24)
                    green = Int((hexNumber & 0x00ff0000) >> 16)
                    blue = Int((hexNumber & 0x0000ff00) >> 8)
                    alpha = Int(hexNumber & 0x000000ff)

                    self.init(red: red, green: green, blue: blue, opacity: alpha)
                    return
                }
            } else if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    red = Int((hexNumber & 0xff0000) >> 16)
                    green = Int((hexNumber & 0x00ff00) >> 8)
                    blue = Int(hexNumber & 0x0000ff)

                    self.init(red: red, green: green, blue: blue)
                    return
                }
            }
        }

        self.init(white: 0)
    }

    /// Multiplies the opacity of this color by the given amount.
    /// - Parameter opacity: How much to adjust the opacity by.
    /// - Returns: A new color with the opacity value taken into account. Note:
    /// because this multiplies the existing opacity, this cannot produce a color that
    /// is more opaque than the original.
    public func opacity(_ opacity: Double) -> Self {
        var copy = self
        copy.opacity = Int(Double(copy.opacity) * opacity)
        return copy
    }
}

// swiftlint:enable file_length
