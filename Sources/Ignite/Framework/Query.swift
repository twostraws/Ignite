//
// Query.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that represents a CSS media query condition.
public protocol Query: Equatable, Hashable, Sendable {
    /// The raw CSS media feature string.
    var condition: String { get }
}

/// Applies styles based on the user's preferred color scheme.
public enum ColorSchemeQuery: String, Query, CaseIterable {
    /// Dark mode preference
    case dark = "prefers-color-scheme: dark"
    /// Light mode preference
    case light = "prefers-color-scheme: light"

    public var condition: String { rawValue }
}

/// Applies styles based on the user's motion preferences.
public enum MotionQuery: String, Query, CaseIterable {
    /// Reduced motion preference
    case reduced = "prefers-reduced-motion: reduce"
    /// Standard motion preference
    case allowed = "prefers-reduced-motion: no-preference"

    public var condition: String { rawValue }
}

/// Applies styles based on the user's contrast preferences.
public enum ContrastQuery: String, Query, CaseIterable {
    /// Standard contrast preference
    case normal = "prefers-contrast: no-preference"
    /// High contrast preference
    case high = "prefers-contrast: more"
    /// Low contrast preference
    case low = "prefers-contrast: less"

    public var condition: String { rawValue }
}

/// Applies styles based on the user's transparency preferences.
public enum TransparencyQuery: String, Query, CaseIterable {
    /// Reduced transparency preference
    case reduced = "prefers-reduced-transparency: reduce"
    /// Standard transparency preference
    case normal = "prefers-reduced-transparency: no-preference"

    public var condition: String { rawValue }
}

/// Applies styles based on the device orientation.
public enum OrientationQuery: String, Query, CaseIterable {
    /// Portrait orientation
    case portrait = "orientation: portrait"
    /// Landscape orientation
    case landscape = "orientation: landscape"

    public var condition: String { rawValue }
}

/// Applies styles based on the web application's display mode.
public enum DisplayModeQuery: String, Query, CaseIterable {
    /// Standard browser mode
    case browser = "display-mode: browser"
    /// Full screen mode
    case fullscreen = "display-mode: fullscreen"
    /// Minimal UI mode
    case minimalUI = "display-mode: minimal-ui"
    /// Picture-in-picture mode
    case pip = "display-mode: picture-in-picture"
    /// Standalone application mode
    case standalone = "display-mode: standalone"
    /// Window controls overlay mode
    case windowControlsOverlay = "display-mode: window-controls-overlay"

    public var condition: String { rawValue }
}

/// Applies styles based on the current theme.
public struct ThemeQuery: Query {
    /// The theme identifier
    let theme: any Theme.Type

    public init(_ theme: any Theme.Type) {
        self.theme = theme
    }

    public var condition: String {
        "data-bs-theme^=\"\(theme.idPrefix)\""
    }

    nonisolated public func hash(into hasher: inout Hasher) {
        hasher.combine(theme.idPrefix)
    }

    nonisolated public static func == (lhs: ThemeQuery, rhs: ThemeQuery) -> Bool {
        lhs.theme.idPrefix == rhs.theme.idPrefix
    }
}

/// Applies styles based on viewport width breakpoints
public enum BreakpointQuery: Query, CaseIterable, Sendable {
    /// Small breakpoint (typically ≥576px)
    case small
    /// Medium breakpoint (typically ≥768px)
    case medium
    /// Large breakpoint (typically ≥992px)
    case large
    /// Extra large breakpoint (typically ≥1200px)
    case xLarge
    /// Extra extra large breakpoint (typically ≥1400px)
    case xxLarge

    /// Creates a breakpoint from a string identifier.
    init?(_ breakpoint: Breakpoint) {
        switch breakpoint {
        case .small: self = .small
        case .medium: self = .medium
        case .large: self = .large
        case .xLarge: self = .xLarge
        case .xxLarge: self = .xxLarge
        default: return nil
        }
    }

    /// Returns the CSS media query string for this breakpoint using the provided theme's values.
    /// - Parameter theme: The theme to use for breakpoint values.
    /// - Returns: A CSS media query string.
    @MainActor func condition(for theme: any Theme) -> String {
        let responsiveValues = theme.breakpoints.values
        let breakpointValue = switch self {
        case .small: (responsiveValues[.small] ?? Bootstrap.smallBreakpoint).stringValue
        case .medium: (responsiveValues[.medium] ?? Bootstrap.mediumBreakpoint).stringValue
        case .large: (responsiveValues[.large] ?? Bootstrap.largeBreakpoint).stringValue
        case .xLarge: (responsiveValues[.xLarge] ?? Bootstrap.xLargeBreakpoint).stringValue
        case .xxLarge: (responsiveValues[.xxLarge] ?? Bootstrap.xxLargeBreakpoint).stringValue
        }
        return "min-width: \(breakpointValue)"
    }

    /// The raw CSS media query string for Ignite's default breakpoints.
    /// - Note: For `Theme`-specific values, use `condition(for:)` instead.
    public var condition: String {
        let breakpointValue = switch self {
        case .small: Bootstrap.smallBreakpoint.stringValue
        case .medium: Bootstrap.mediumBreakpoint.stringValue
        case .large: Bootstrap.largeBreakpoint.stringValue
        case .xLarge: Bootstrap.xLargeBreakpoint.stringValue
        case .xxLarge: Bootstrap.xxLargeBreakpoint.stringValue
        }
        return "min-width: \(breakpointValue)"
    }
}

// MARK: - Static Factory Methods

public extension Query where Self == ColorSchemeQuery {
    /// Creates a color scheme media query.
    /// - Parameter scheme: The color scheme to apply.
    /// - Returns: A color scheme media query.
    static func colorScheme(_ scheme: ColorSchemeQuery) -> ColorSchemeQuery {
        scheme
    }
}

public extension Query where Self == MotionQuery {
    /// Creates a motion preference media query.
    /// - Parameter motion: The motion preference to apply.
    /// - Returns: A motion preference media query.
    static func motion(_ motion: MotionQuery) -> MotionQuery {
        motion
    }
}

public extension Query where Self == ContrastQuery {
    /// Creates a contrast preference media query.
    /// - Parameter contrast: The contrast preference to apply.
    /// - Returns: A contrast preference media query.
    static func contrast(_ contrast: ContrastQuery) -> ContrastQuery {
        contrast
    }
}

public extension Query where Self == TransparencyQuery {
    /// Creates a transparency preference media query.
    /// - Parameter transparency: The transparency preference to apply.
    /// - Returns: A transparency preference media query.
    static func transparency(_ transparency: TransparencyQuery) -> TransparencyQuery {
        transparency
    }
}

public extension Query where Self == OrientationQuery {
    /// Creates an orientation media query.
    /// - Parameter orientation: The orientation to apply.
    /// - Returns: An orientation media query.
    static func orientation(_ orientation: OrientationQuery) -> OrientationQuery {
        orientation
    }
}

public extension Query where Self == DisplayModeQuery {
    /// Creates a display mode media query.
    /// - Parameter mode: The display mode to apply.
    /// - Returns: A display mode media query.
    static func displayMode(_ mode: DisplayModeQuery) -> DisplayModeQuery {
        mode
    }
}

public extension Query where Self == ThemeQuery {
    /// Creates a theme media query.
    /// - Parameter theme: The type of theme.
    /// - Returns: A theme media query.
    static func theme(_ theme: any Theme.Type) -> ThemeQuery {
        ThemeQuery(theme)
    }
}

public extension Query where Self == BreakpointQuery {
    /// Creates a breakpoint media query.
    /// - Parameter breakpoint: The breakpoint to apply.
    /// - Returns: A breakpoint media query.
    static func breakpoint(_ breakpoint: BreakpointQuery) -> BreakpointQuery {
        breakpoint
    }
}
