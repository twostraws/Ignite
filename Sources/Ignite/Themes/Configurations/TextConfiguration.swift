//
// ParagraphConfiguration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines the visual styling for text elements
public protocol TextThemeConfiguration {
    /// The font family used for text
    var font: Font? { get set }

    /// Standard line height for text
    var lineSpacing: LengthUnit? { get set }

    /// Bottom margin for text blocks
    var bottomMargin: LengthUnit? { get set }

    /// The text color
    var color: Color? { get set }

    /// Text sizes at different responsive breakpoints
    var sizes: ResponsiveValues<LengthUnit>? { get set }

    /// Creates a new text configuration
    init(
        font: Font?,
        lineSpacing: LengthUnit?,
        bottomMargin: LengthUnit?,
        color: Color?,
        sizes: ResponsiveValues<LengthUnit>?
    )
}

/// A configuration that defines text styling for light mode themes
public struct TextLightConfiguration: TextThemeConfiguration {
    /// The font family used for text
    public var font: Font?

    /// The line height for text blocks
    public var lineSpacing: LengthUnit?

    /// The bottom margin for text blocks
    public var bottomMargin: LengthUnit?

    /// The text color
    public var color: Color?

    /// Text sizes at different responsive breakpoints
    public var sizes: ResponsiveValues<LengthUnit>?

    /// Creates a new light mode text configuration
    /// - Parameters:
    ///   - font: The font family. Pass `nil` to use theme default.
    ///   - lineSpacing: The line height. Pass `nil` to use theme default.
    ///   - bottomMargin: The bottom margin. Pass `nil` to use theme default.
    ///   - color: The text color. Pass `nil` to use Bootstrap light default.
    ///   - sizes: The text sizes for each breakpoint. Pass `nil` to use Bootstrap defaults.
    public init(
        font: Font? = nil,
        lineSpacing: LengthUnit? = nil,
        bottomMargin: LengthUnit? = nil,
        color: Color? = nil,
        sizes: ResponsiveValues<LengthUnit>? = nil
    ) {
        self.font = font
        self.lineSpacing = lineSpacing
        self.bottomMargin = bottomMargin
        self.color = color ?? Bootstrap.Light.TextColors.primary
        self.sizes = sizes
    }
}

/// A configuration that defines text styling for dark mode themes
public struct TextDarkConfiguration: TextThemeConfiguration {
    /// The font family used for text
    public var font: Font?

    /// The line height for text blocks
    public var lineSpacing: LengthUnit?

    /// The bottom margin for text blocks
    public var bottomMargin: LengthUnit?

    /// The text color
    public var color: Color?

    /// Text sizes at different responsive breakpoints
    public var sizes: ResponsiveValues<LengthUnit>?

    /// Creates a new dark mode text configuration
    /// - Parameters:
    ///   - font: The font family. Pass `nil` to use theme default.
    ///   - lineSpacing: The line height. Pass `nil` to use theme default.
    ///   - bottomMargin: The bottom margin. Pass `nil` to use theme default.
    ///   - color: The text color. Pass `nil` to use Bootstrap dark default.
    ///   - sizes: The text sizes for each breakpoint. Pass `nil` to use Bootstrap defaults.
    public init(
        font: Font? = nil,
        lineSpacing: LengthUnit? = nil,
        bottomMargin: LengthUnit? = nil,
        color: Color? = nil,
        sizes: ResponsiveValues<LengthUnit>? = nil
    ) {
        self.font = font
        self.lineSpacing = lineSpacing
        self.bottomMargin = bottomMargin
        self.color = color ?? Bootstrap.Dark.TextColors.primary
        self.sizes = sizes
    }
}
