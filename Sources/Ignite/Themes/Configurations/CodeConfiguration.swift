//
// CodeConfiguration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines the visual styling for code elements
public protocol CodeThemeConfiguration {
    /// The font family used for code elements
    var font: Font? { get set }

    /// The font size for inline code elements
    var inlineSize: LengthUnit? { get set }

    /// The font size for code blocks
    var blockSize: LengthUnit? { get set }

    /// The color scheme for syntax highlighting
    var syntaxHighlighterTheme: HighlighterTheme? { get set }

    /// Creates a new code configuration
    init(
        font: Font?,
        inlineSize: LengthUnit?,
        blockSize: LengthUnit?,
        syntaxHighlighterTheme: HighlighterTheme?
    )
}

/// A configuration that defines code styling for light mode themes
public struct CodeLightConfiguration: CodeThemeConfiguration {
    /// The font family used for code elements
    public var font: Font?

    /// The font size for inline code elements
    public var inlineSize: LengthUnit?

    /// The font size for code blocks
    public var blockSize: LengthUnit?

    /// The syntax highlighting theme for code blocks
    public var syntaxHighlighterTheme: HighlighterTheme?

    /// Creates a new light mode code configuration
    /// - Parameters:
    ///   - font: The font family for code. Pass `nil` to use system monospace.
    ///   - inlineSize: The size for inline code. Pass `nil` to use theme default.
    ///   - blockSize: The size for code blocks. Pass `nil` to use theme default.
    ///   - syntaxHighlighterTheme: The highlighting theme. Defaults to automatic.
    public init(
        font: Font? = nil,
        inlineSize: LengthUnit? = nil,
        blockSize: LengthUnit? = nil,
        syntaxHighlighterTheme: HighlighterTheme? = .automatic
    ) {
        self.font = font
        self.inlineSize = inlineSize
        self.blockSize = blockSize
        self.syntaxHighlighterTheme = syntaxHighlighterTheme
    }
}

/// A configuration that defines code styling for dark mode themes
public struct CodeDarkConfiguration: CodeThemeConfiguration {
    /// The font family used for code elements
    public var font: Font?

    /// The font size for inline code elements
    public var inlineSize: LengthUnit?

    /// The font size for code blocks
    public var blockSize: LengthUnit?

    /// The syntax highlighting theme for code blocks
    public var syntaxHighlighterTheme: HighlighterTheme?

    /// Creates a new dark mode code configuration
    /// - Parameters:
    ///   - font: The font family for code. Pass `nil` to use system monospace.
    ///   - inlineSize: The size for inline code. Pass `nil` to use theme default.
    ///   - blockSize: The size for code blocks. Pass `nil` to use theme default.
    ///   - syntaxHighlighterTheme: The highlighting theme. Defaults to Xcode dark.
    public init(
        font: Font? = nil,
        inlineSize: LengthUnit? = nil,
        blockSize: LengthUnit? = nil,
        syntaxHighlighterTheme: HighlighterTheme? = .xcodeDark
    ) {
        self.font = font
        self.inlineSize = inlineSize
        self.blockSize = blockSize
        self.syntaxHighlighterTheme = syntaxHighlighterTheme
    }
}
