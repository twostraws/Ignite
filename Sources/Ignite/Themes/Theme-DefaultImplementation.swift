//
// Theme-DefaultImplementation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Default implementation providing Bootstrap's default light theme values
public extension Theme {
    var colorPalette: ColorPaletteLightConfiguration { ColorPaletteLightConfiguration() }
    var rootFontSize: LengthUnit? { nil }
    var text: TextLightConfiguration { TextLightConfiguration() }
    var code: CodeLightConfiguration { CodeLightConfiguration() }
    var headings: HeadingLightConfiguration { HeadingLightConfiguration() }
    var links: LinkLightConfiguration { LinkLightConfiguration() }
    var siteWidths: SiteWidthConfiguration { .init() }
    var breakpoints: BreakpointConfiguration { .init() }
}

public extension Theme {
    /// The unique identifier for this theme instance, including any system-generated suffix.
    var id: String {
        Self.id
    }

    /// The display name of this theme instance.
    var name: String {
        Self.name
    }

    /// Internal identifier used for theme switching and CSS selectors.
    /// Automatically appends "-light" or "-dark" suffix based on protocol conformance.
    static var id: String {
        let baseID = name.kebabCased()

        guard baseID != "light" && baseID != "dark" else {
            return baseID
        }

        switch self {
        case is any LightTheme.Type: return baseID + "-light"
        case is any DarkTheme.Type: return baseID + "-dark"
        default: return baseID
        }
    }
}
