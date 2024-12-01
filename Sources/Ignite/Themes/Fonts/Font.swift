//
// Font.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A type that represents a font configuration including style, size, and weight
public struct Font: Hashable, Equatable, Sendable {
    /// The name of the font family, if using a custom font.
    let name: String?

    /// An array of font sources defining where the font files can be found.
    let sources: [FontSource]

    /// The semantic level of the font, such as title or body text.
    let style: Font.Style?

    /// The size of the font in pixels, if specified.
    let size: Double?

    /// The weight (boldness) of the font.
    let weight: Font.Weight

    /// Constants that define the style of the font.
    public enum Variant: String, Sendable {
        /// The default upright style of the font.
        case normal
        /// An italicized version of the font.
        case italic
        /// A slanted version of the font, similar to italic but mechanically slanted.
        case oblique
    }

    /// A string containing the default system font stack.
    public static let systemFonts = """
    system-ui, -apple-system, "Segoe UI", \
    Roboto, "Helvetica Neue", Arial, \
    "Noto Sans", "Liberation Sans", sans-serif
    """

    /// A string containing the default monospace font stack.
    public static let monospaceFonts = """
    SFMono-Regular, Menlo, Monaco, \
    Consolas, "Liberation Mono", \
    "Courier New", monospace
    """

    /// The default sans-serif system font.
    public static let systemSansSerif = Font(name: systemFonts, weight: .regular)

    /// The default monospace system font.
    public static let systemMonospace = Font(name: monospaceFonts, weight: .regular)

    /// The default font used for body text.
    public static let systemBodyFont = systemSansSerif

    /// The default font used for code blocks.
    public static let systemCodeFont = systemMonospace

    /// Creates a font with the specified properties.
    /// - Parameters:
    ///   - name: The name of the font family.
    ///   - level: The semantic level of the font.
    ///   - size: The size of the font in pixels.
    ///   - weight: The weight (boldness) of the font.
    ///   - sources: An array of font sources defining where the font files can be found.
    public init(
        name: String? = nil,
        style: Font.Style? = nil,
        size: Double? = nil,
        weight: Font.Weight = .regular,
        sources: [FontSource] = []
    ) {
        self.name = name
        self.sources = sources
        self.style = style
        self.size = size
        self.weight = weight
    }

    /// Creates a font with the specified name and font sources.
    /// - Parameters:
    ///   - name: The name of the font family.
    ///   - sources: A variadic list of font sources defining where the font files can be found.
    public init(name: String? = nil, sources: FontSource...) {
        self.init(name: name, sources: sources)
    }

    /// Creates a font with a single web font source.
    /// - Parameters:
    ///   - name: The name of the font family.
    ///   - level: The semantic level of the font, defaulting to body text.
    ///   - source: A URL string pointing to the font file.
    /// - Note: This initializer assumes the source URL is valid and force-unwraps it.
    public init(name: String, style: Font.Style = .body, source: String) {
        self.init(name: name, style: style, sources: [FontSource(name: source, url: URL(string: source)!)])
    }

    /// Creates a system font with the specified style
    /// - Parameter style: The font style to use
    /// - Returns: A Font instance configured with the system font
    static func system(_ style: Font.Style, size: Double?, weight: Font.Weight = .regular) -> Font {
        Font(style: style, size: nil, weight: weight)
    }

    /// Creates a system font with the specified style and size
    /// - Parameters:
    ///   - style: The font style to use
    ///   - size: The size of the font in pixels
    ///   - weight: The weight (boldness) of the font
    /// - Returns: A Font instance configured with the system font
    static func system(_ style: Font.Style, size: Double, weight: Font.Weight = .regular) -> Font {
        Font(style: style, size: size, weight: weight)
    }

    /// Creates a custom font with the specified name and size
    /// - Parameters:
    ///   - name: The name of the font file including its extension
    ///   - size: The size of the font in pixels
    ///   - weight: The weight (boldness) of the font
    /// - Returns: A Font instance configured with the custom font
    static func custom(_ name: String, style: Font.Style = .body, size: Double, weight: Font.Weight = .regular) -> Font {
        Font(style: style, size: size, weight: weight, sources: [FontSource(name: name)])
    }

    /// Creates a system font from a comma-separated string of font families
    /// - Parameter families: A comma-separated string of font family names
    /// - Returns: A Font instance configured with the system font families
    static func system(families: String) -> Font {
        Font(name: families, style: nil, size: nil, weight: .regular)
    }
}
