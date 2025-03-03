//
// ColorPaletteConfiguration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines a complete color system for a theme
public protocol ColorPaletteThemeConfiguration {
    // MARK: - Brand Colors

    /// Primary brand color used for main call-to-action elements
    var accent: Color? { get set }

    /// Secondary brand color used for supporting interface elements
    var secondaryAccent: Color? { get set }

    // MARK: - Semantic Colors

    /// Color indicating successful operations, typically green
    var success: Color? { get set }

    /// Color for informational messages, typically blue
    var info: Color? { get set }

    /// Color indicating caution or potential issues, typically yellow/orange
    var warning: Color? { get set }

    /// Color for error states and destructive actions, typically red
    var danger: Color? { get set }

    // MARK: - Neutral Colors

    /// Soft white color used for subtle contrast
    var offWhite: Color? { get set }

    /// Soft black color used for reduced harshness
    var offBlack: Color? { get set }

    // MARK: - Text Colors

    /// Medium-contrast color for supporting text
    var secondaryText: Color? { get set }

    /// Low-contrast color for placeholder text
    var tertiaryText: Color? { get set }

    /// High-contrast color for emphasized text
    var emphasis: Color? { get set }

    // MARK: - Background Colors

    /// Primary surface color for main content areas
    var background: Color? { get set }

    /// Alternative background for visual separation
    var secondaryBackground: Color? { get set }

    /// Subtle background for nested sections
    var tertiaryBackground: Color? { get set }

    /// Color for borders and dividers
    var border: Color? { get set }

    /// Creates a new color palette configuration
    init(
        accent: Color?,
        secondaryAccent: Color?,
        success: Color?,
        info: Color?,
        warning: Color?,
        danger: Color?,
        offWhite: Color?,
        offBlack: Color?,
        emphasis: Color?,
        secondaryText: Color?,
        tertiaryText: Color?,
        background: Color?,
        secondaryBackground: Color?,
        tertiaryBackground: Color?,
        border: Color?
    )
}

/// A color palette configuration for light mode themes
public struct ColorPaletteLightConfiguration: ColorPaletteThemeConfiguration {
    // MARK: - Brand Colors

    /// Primary brand color for key interactive elements
    public var accent: Color?

    /// Secondary brand color for supporting elements
    public var secondaryAccent: Color?

    // MARK: - Semantic Colors

    /// Color indicating successful operations, typically green
    public var success: Color?

    /// Color for informational messages, typically blue
    public var info: Color?

    /// Color indicating caution states, typically yellow/orange
    public var warning: Color?

    /// Color for error states, typically red
    public var danger: Color?

    // MARK: - Neutral Colors

    /// Soft white color for subtle contrast
    public var offWhite: Color?

    /// Soft black color for reduced harshness
    public var offBlack: Color?

    // MARK: - Text Colors

    /// High-contrast color for emphasized text
    public var emphasis: Color?

    /// Medium-contrast color for supporting text
    public var secondaryText: Color?

    /// Low-contrast color for placeholder text
    public var tertiaryText: Color?

    // MARK: - Background Colors

    /// Primary surface color for content areas
    public var background: Color?

    /// Alternative background for visual separation
    public var secondaryBackground: Color?

    /// Subtle background for nested sections
    public var tertiaryBackground: Color?

    /// Color for borders and dividers
    public var border: Color?

    /// Creates a new light mode color palette configuration
    /// - Parameters:
    ///   - accent: Primary brand color. Pass `nil` to use Bootstrap default.
    ///   - secondaryAccent: Secondary brand color. Pass `nil` to use Bootstrap default.
    ///   - success: Success state color. Pass `nil` to use Bootstrap default.
    ///   - info: Information state color. Pass `nil` to use Bootstrap default.
    ///   - warning: Warning state color. Pass `nil` to use Bootstrap default.
    ///   - danger: Error state color. Pass `nil` to use Bootstrap default.
    ///   - offWhite: Light neutral color. Pass `nil` to use Bootstrap default.
    ///   - offBlack: Dark neutral color. Pass `nil` to use Bootstrap default.
    ///   - emphasis: Emphasized text color. Pass `nil` to use Bootstrap default.
    ///   - text: Primary text color. Pass `nil` to use Bootstrap default.
    ///   - secondaryText: Supporting text color. Pass `nil` to use Bootstrap default.
    ///   - tertiaryText: Placeholder text color. Pass `nil` to use Bootstrap default.
    ///   - heading: Heading text color. Pass `nil` to use Bootstrap default.
    ///   - link: Link color. Pass `nil` to use Bootstrap default.
    ///   - hoveredLink: Link hover color. Pass `nil` to use Bootstrap default.
    ///   - background: Primary background color. Pass `nil` to use Bootstrap default.
    ///   - secondaryBackground: Alternative background color. Pass `nil` to use Bootstrap default.
    ///   - tertiaryBackground: Subtle background color. Pass `nil` to use Bootstrap default.
    ///   - border: Border color. Pass `nil` to use Bootstrap default.
    public init(
        accent: Color? = nil,
        secondaryAccent: Color? = nil,
        success: Color? = nil,
        info: Color? = nil,
        warning: Color? = nil,
        danger: Color? = nil,
        offWhite: Color? = nil,
        offBlack: Color? = nil,
        emphasis: Color? = nil,
        secondaryText: Color? = nil,
        tertiaryText: Color? = nil,
        background: Color? = nil,
        secondaryBackground: Color? = nil,
        tertiaryBackground: Color? = nil,
        border: Color? = nil
    ) {
        self.accent = accent ?? Bootstrap.Light.ThemeColors.accent
        self.secondaryAccent = secondaryAccent ?? Bootstrap.Light.ThemeColors.secondaryAccent
        self.success = success ?? Bootstrap.Light.SemanticColors.success
        self.info = info ?? Bootstrap.Light.SemanticColors.info
        self.warning = warning ?? Bootstrap.Light.SemanticColors.warning
        self.danger = danger ?? Bootstrap.Light.SemanticColors.danger
        self.offWhite = offWhite ?? Bootstrap.Light.ThemeColors.light
        self.offBlack = offBlack ?? Bootstrap.Light.ThemeColors.dark
        self.emphasis = emphasis ?? Bootstrap.Light.TextColors.emphasis
        self.secondaryText = secondaryText ?? Bootstrap.Light.TextColors.secondary
        self.tertiaryText = tertiaryText ?? Bootstrap.Light.TextColors.tertiary
        self.background = background ?? Bootstrap.Light.BackgroundColors.primary
        self.secondaryBackground = secondaryBackground ?? Bootstrap.Light.BackgroundColors.secondary
        self.tertiaryBackground = tertiaryBackground ?? Bootstrap.Light.BackgroundColors.tertiary
        self.border = border ?? Bootstrap.Light.ThemeColors.border
    }
}

/// A color palette configuration for dark mode themes
public struct ColorPaletteDarkConfiguration: ColorPaletteThemeConfiguration {
    // MARK: - Brand Colors

    /// Primary brand color for key interactive elements
    public var accent: Color?

    /// Secondary brand color for supporting elements
    public var secondaryAccent: Color?

    // MARK: - Semantic Colors

    /// Color indicating successful operations, typically green
    public var success: Color?

    /// Color for informational messages, typically blue
    public var info: Color?

    /// Color indicating caution states, typically yellow/orange
    public var warning: Color?

    /// Color for error states, typically red
    public var danger: Color?

    // MARK: - Neutral Colors

    /// Soft white color for subtle contrast
    public var offWhite: Color?

    /// Soft black color for reduced harshness
    public var offBlack: Color?

    // MARK: - Text Colors

    /// High-contrast color for emphasized text
    public var emphasis: Color?

    /// Medium-contrast color for supporting text
    public var secondaryText: Color?

    /// Low-contrast color for placeholder text
    public var tertiaryText: Color?

    // MARK: - Background Colors

    /// Primary surface color for content areas
    public var background: Color?

    /// Alternative background for visual separation
    public var secondaryBackground: Color?

    /// Subtle background for nested sections
    public var tertiaryBackground: Color?

    /// Color for borders and dividers
    public var border: Color?

    /// Creates a new dark mode color palette configuration
    /// - Parameters:
    ///   - accent: Primary brand color. Pass `nil` to use Bootstrap default.
    ///   - secondaryAccent: Secondary brand color. Pass `nil` to use Bootstrap default.
    ///   - success: Success state color. Pass `nil` to use Bootstrap default.
    ///   - info: Information state color. Pass `nil` to use Bootstrap default.
    ///   - warning: Warning state color. Pass `nil` to use Bootstrap default.
    ///   - danger: Error state color. Pass `nil` to use Bootstrap default.
    ///   - offWhite: Light neutral color. Pass `nil` to use Bootstrap default.
    ///   - offBlack: Dark neutral color. Pass `nil` to use Bootstrap default.
    ///   - secondaryText: Supporting text color. Pass `nil` to use Bootstrap default.
    ///   - tertiaryText: Placeholder text color. Pass `nil` to use Bootstrap default.
    ///   - background: Primary background color. Pass `nil` to use Bootstrap default.
    ///   - secondaryBackground: Alternative background color. Pass `nil` to use Bootstrap default.
    ///   - tertiaryBackground: Subtle background color. Pass `nil` to use Bootstrap default.
    ///   - border: Border color. Pass `nil` to use Bootstrap default.
    public init(
        accent: Color? = nil,
        secondaryAccent: Color? = nil,
        success: Color? = nil,
        info: Color? = nil,
        warning: Color? = nil,
        danger: Color? = nil,
        offWhite: Color? = nil,
        offBlack: Color? = nil,
        emphasis: Color? = nil,
        secondaryText: Color? = nil,
        tertiaryText: Color? = nil,
        background: Color? = nil,
        secondaryBackground: Color? = nil,
        tertiaryBackground: Color? = nil,
        border: Color? = nil
    ) {
        self.accent = accent ?? Bootstrap.Dark.ThemeColors.accent
        self.secondaryAccent = secondaryAccent ?? Bootstrap.Dark.ThemeColors.secondaryAccent
        self.success = success ?? Bootstrap.Dark.SemanticColors.success
        self.info = info ?? Bootstrap.Dark.SemanticColors.info
        self.warning = warning ?? Bootstrap.Dark.SemanticColors.warning
        self.danger = danger ?? Bootstrap.Dark.SemanticColors.danger
        self.offWhite = offWhite ?? Bootstrap.Dark.ThemeColors.light
        self.offBlack = offBlack ?? Bootstrap.Dark.ThemeColors.dark
        self.emphasis = emphasis ?? Bootstrap.Dark.TextColors.emphasis
        self.secondaryText = secondaryText ?? Bootstrap.Dark.TextColors.secondary
        self.tertiaryText = tertiaryText ?? Bootstrap.Dark.TextColors.tertiary
        self.background = background ?? Bootstrap.Dark.BackgroundColors.primary
        self.secondaryBackground = secondaryBackground ?? Bootstrap.Dark.BackgroundColors.secondary
        self.tertiaryBackground = tertiaryBackground ?? Bootstrap.Dark.BackgroundColors.tertiary
        self.border = border ?? Bootstrap.Dark.ThemeColors.border
    }
}
