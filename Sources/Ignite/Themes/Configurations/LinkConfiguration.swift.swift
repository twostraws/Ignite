//
// LinkConfiguration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines the visual styling for links.
public protocol LinkThemeConfiguration {
    /// The color for links in their normal state
    var normal: Color? { get set }

    /// The color for links when hovered
    var hover: Color? { get set }

    /// The text decoration style for links
    var decoration: TextDecoration? { get set }

    /// Creates a new link configuration
    init(
        normal: Color?,
        hover: Color?,
        decoration: TextDecoration?
    )
}

/// A configuration that defines link styling for light mode themes
public struct LinkLightConfiguration: LinkThemeConfiguration {
    /// The color for links in their normal state
    public var normal: Color?

    /// The color for links when hovered
    public var hover: Color?

    /// The text decoration style for links (e.g., underline)
    public var decoration: TextDecoration?

    /// Creates a new light mode link configuration
    /// - Parameters:
    ///   - normal: The default link color. Pass `nil` to use Bootstrap light default.
    ///   - hover: The hover state color. Pass `nil` to use Bootstrap light default.
    ///   - decoration: The text decoration. Defaults to underline.
    public init(
        normal: Color? = nil,
        hover: Color? = nil,
        decoration: TextDecoration? = .underline
    ) {
        self.normal = normal ?? Bootstrap.Light.Link.normal
        self.hover = hover ?? Bootstrap.Light.Link.hover
        self.decoration = decoration
    }
}

/// A configuration that defines link styling for dark mode themes
public struct LinkDarkConfiguration: LinkThemeConfiguration {
    /// The color for links in their normal state
    public var normal: Color?

    /// The color for links when hovered
    public var hover: Color?

    /// The text decoration style for links (e.g., underline)
    public var decoration: TextDecoration?

    /// Creates a new dark mode link configuration
    /// - Parameters:
    ///   - normal: The default link color. Pass `nil` to use Bootstrap dark default.
    ///   - hover: The hover state color. Pass `nil` to use Bootstrap dark default.
    ///   - decoration: The text decoration. Defaults to underline.
    public init(
        normal: Color? = nil,
        hover: Color? = nil,
        decoration: TextDecoration? = .underline
    ) {
        self.normal = normal ?? Bootstrap.Dark.Link.normal
        self.hover = hover ?? Bootstrap.Dark.Link.hover
        self.decoration = decoration
    }
}
