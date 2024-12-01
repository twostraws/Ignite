//
// FontSource.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A type that represents a source for a font, including its name, weight, style, and location.
///
/// Use `FontSource` to define where font files can be found and their properties. For example:
///
/// ```swift
/// // Local font
/// var fontFamilyBase = Font(
///     name: "valkyrie_a_regular",
///     source: "/fonts/valkyrie_a_regular.woff2"
/// )
///
/// // Remote font
/// var fontFamilyBase = Font(
///     name: "Lato",
///     source: "https://fonts.googleapis.com/css2?family=Lato" +
///            "?ital,wght@" +
///            "0,100;" +  // normal thin
///            "0,300;" +  // normal light
///            "0,400;" +  // normal regular
///            "0,700;" +  // normal bold
///            "0,900;" +  // normal black
///            "1,100;" +  // italic thin
///            "1,300;" +  // italic light
///            "1,400;" +  // italic regular
///            "1,700;" +  // italic bold
///            "1,900" +   // italic black
///            "&display=swap"
/// )
/// ```
public struct FontSource: Hashable, Equatable, Sendable {
    /// The name of the font file or family.
    let name: String

    /// The weight (boldness) of this font variant.
    let weight: Font.Weight

    /// The style (normal, italic, or oblique) of this font variant.
    let style: Font.Variant

    /// The URL where the font file can be found, if it's a web font.
    let url: URL?

    /// Creates a font source with a remote URL.
    /// - Parameters:
    ///   - name: The name of the font file or family.
    ///   - weight: The weight of this font variant, defaulting to regular.
    ///   - style: The style of this font variant, defaulting to normal.
    ///   - url: The URL where the font file can be found.
    public init(
        name: String,
        weight: Font.Weight = .regular,
        style: Font.Variant = .normal,
        url: URL
    ) {
        self.name = name
        self.url = url
        self.weight = weight
        self.style = style
    }

    /// Creates a font source for a local font file.
    /// - Parameters:
    ///   - name: The name of the font file or family.
    ///   - weight: The weight of this font variant, defaulting to regular.
    ///   - style: The style of this font variant, defaulting to normal.
    init(
        name: String,
        weight: Font.Weight = .regular,
        style: Font.Variant = .normal
    ) {
        self.name = name
        self.weight = weight
        self.style = style
        self.url = nil
    }
}
