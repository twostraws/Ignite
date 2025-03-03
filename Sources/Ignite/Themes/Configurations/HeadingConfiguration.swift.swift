//
// HeadingConfiguration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines the visual styling for headings
public protocol HeadingThemeConfiguration {
    /// The font family used for headings
    var font: Font? { get set }

    /// The font weight applied to headings
    var fontWeight: FontWeight? { get set }

    /// The bottom margin for headings
    var bottomMargin: LengthUnit? { get set }

    /// The line height for headings
    var lineHeight: LengthUnit? { get set }

    /// The text color for headings
    var color: Color? { get set }

    /// The responsive sizes for each heading level
    var sizes: HeadingSizes? { get set }

    /// Creates a new heading configuration
    init(
        font: Font?,
        fontWeight: FontWeight?,
        bottomMargin: LengthUnit?,
        lineHeight: LengthUnit?,
        color: Color?,
        sizes: HeadingSizes?
    )
}

/// A heading configuration for light mode themes
public struct HeadingLightConfiguration: HeadingThemeConfiguration {
    /// The font family used for headings
    public var font: Font?

    /// The font weight applied to headings
    public var fontWeight: FontWeight?

    /// The bottom margin for headings
    public var bottomMargin: LengthUnit?

    /// The line height for headings
    public var lineHeight: LengthUnit?

    /// The text color for headings
    public var color: Color?

    /// The responsive sizes for each heading level
    public var sizes: HeadingSizes?

    /// Creates a new light mode heading configuration
    /// - Parameters:
    ///   - font: The font family. Pass `nil` to use theme default.
    ///   - fontWeight: The font weight. Pass `nil` to use theme default.
    ///   - bottomMargin: The bottom margin. Pass `nil` to use theme default.
    ///   - lineHeight: The line height. Pass `nil` to use theme default.
    ///   - color: The text color. Pass `nil` to use Bootstrap light default.
    ///   - sizes: The heading sizes. Pass `nil` to use theme default.
    public init(
        font: Font? = nil,
        fontWeight: FontWeight? = nil,
        bottomMargin: LengthUnit? = nil,
        lineHeight: LengthUnit? = nil,
        color: Color? = nil,
        sizes: HeadingSizes? = nil
    ) {
        self.font = font
        self.fontWeight = fontWeight
        self.bottomMargin = bottomMargin
        self.lineHeight = lineHeight
        self.color = color ?? Bootstrap.Light.TextColors.primary
        self.sizes = sizes
    }
}

/// A heading configuration for dark mode themes
public struct HeadingDarkConfiguration: HeadingThemeConfiguration {
    /// The font family used for headings
    public var font: Font?

    /// The font weight applied to headings
    public var fontWeight: FontWeight?

    /// The bottom margin for headings
    public var bottomMargin: LengthUnit?

    /// The line height for headings
    public var lineHeight: LengthUnit?

    /// The text color for headings
    public var color: Color?

    /// The responsive sizes for each heading level
    public var sizes: HeadingSizes?

    /// Creates a new dark mode heading configuration
    /// - Parameters:
    ///   - font: The font family. Pass `nil` to use theme default.
    ///   - fontWeight: The font weight. Pass `nil` to use theme default.
    ///   - bottomMargin: The bottom margin. Pass `nil` to use theme default.
    ///   - lineHeight: The line height. Pass `nil` to use theme default.
    ///   - color: The text color. Pass `nil` to use Bootstrap dark default.
    ///   - sizes: The heading sizes. Pass `nil` to use theme default.
    public init(
        font: Font? = nil,
        fontWeight: FontWeight? = nil,
        bottomMargin: LengthUnit? = nil,
        lineHeight: LengthUnit? = nil,
        color: Color? = nil,
        sizes: HeadingSizes? = nil
    ) {
        self.font = font
        self.fontWeight = fontWeight
        self.bottomMargin = bottomMargin
        self.lineHeight = lineHeight
        self.color = color ?? Bootstrap.Dark.TextColors.primary
        self.sizes = sizes
    }
}
