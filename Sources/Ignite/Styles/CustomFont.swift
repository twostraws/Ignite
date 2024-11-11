//
// CustomFont.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public struct CustomFont {
    /// The URL to the font resource (might be local or remote)
    /// - Returns: String containing a valid URL or "Invalid URL: `urlString`"
    public var fontURLString: String {
        fontURL?.absoluteString ?? "Invalid URL: \(urlString)"
    }
    /// The font-family name used in the resource (ex .ttf file)
    public let fontFamily: String
    /// The URL to the font resource (ex .ttf file)
    private let urlString: String
    private var fontURL: URL? {
        URL(string: urlString)
    }

    /// Create a custom font using a font family name and URL string pointing to a font resource
    ///  (such as '/fonts/myFont.ttf' or 'https://fonts.google.com/theirCustomFont')
    /// - Parameters:
    ///   - fontFamily: "The font-family name matching the font-family name in the font resource"
    ///   - urlString: "The URL string to the resource whether that be local or remote"
    ///   - fallbackFontFamilies: font-family names to use as a fallback. They will be used in the order presented if one is unavailable. 
    ///     - NOTE: custom fonts with special characters in the font-family name must be enclosed in single-quotes such as 'my-Cu$t0m-font'
    public init(fontFamily: String, urlString: String, fallbackFontFamilies: [String]? = nil) {
        if let fallbackFontFamilies {
            let fallbackString = fallbackFontFamilies.joined(separator: ", ")
            self.fontFamily = "'\(fontFamily)'," + "\(fallbackString);"
        } else {
            self.fontFamily = "'\(fontFamily)'"
        }

        self.urlString = urlString
    }
}

extension PageElement {
    public func addCustomFontFace(_ customFont: CustomFont) -> Self {
        style("""
        @font-face {
            font-family: '\(customFont.fontFamily)';
            src: url('\(customFont.fontURLString)') 
        }
        """)
    }

    public func useCustomFont(_ customFont: CustomFont) -> Self {
        style("font-family: \(customFont.fontFamily);")
    }
}

// Example Usage
// enum BrandFont: String {
//     case dmSans = "DM Sans"
//     case syne = "Syne"

//     var customFont: CustomFont {
//         switch self {
//         case .dmSans:
//             CustomFont(
//                 fontFamily: rawValue,
//                 urlString: "https://fonts.googleapis.com/css2?family=DM+Sans:ital,opsz,wght@0,9..40,100..1000;1,9..40,100..1000&display=swap",
//                 fallbackFontFamilies: ["sans-serif"]
//             )
//         case .syne:
//             CustomFont(
//                 fontFamily: rawValue,
//                 urlString: "https://fonts.googleapis.com/css2?family=DM+Sans:ital,opsz,wght@0,9..40,100..1000;1,9..40,100..1000&family=Syne:wght@400..800&display=swap",
//                 fallbackFontFamilies: ["serif"]
//             )
//         }
//     }
// }
//
// struct MyTheme: Theme {
//     func render(page: Page, context: PublishingContext) -> HTML {
//         HTML {
//             Head(for: page, in: context)
//             Body {
//                 page.body
//             }
//             .addCustomFontFace(BrandFontStyle.dmSans.customFont)
//             .addCustomFontFace(BrandFontStyle.syne.customFont)
//             .useCustomFont(BrandFontStyle.dmSans.customFont)
//         }
//     }
// }
