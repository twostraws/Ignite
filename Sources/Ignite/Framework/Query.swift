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

    /// Returns the CSS media feature string for this condition using theme-specific values if relevant.
    /// - Parameter theme: The theme to use for generating the query.
    /// - Returns: A theme-aware CSS media query string.
    @MainActor func condition(with theme: Theme) -> String
}

public extension Query {
    @MainActor func condition(with theme: Theme) -> String {
        condition
    }
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
    let id: String

    public init(_ id: String) {
        self.id = id
    }

    public var condition: String {
        "data-theme-state=\"\(id.kebabCased())\""
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: ThemeQuery, rhs: ThemeQuery) -> Bool {
        lhs.id == rhs.id
    }
}

/// Applies styles based on viewport width breakpoints
public enum BreakpointQuery: Query, CaseIterable, Sendable {
    /// Extra small breakpoint (typically <576px)
    case xSmall
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
    init(_ breakpoint: Breakpoint) {
        switch breakpoint {
        case .xSmall: self = .xSmall
        case .small: self = .small
        case .medium: self = .medium
        case .large: self = .large
        case .xLarge: self = .xLarge
        case .xxLarge: self = .xxLarge
        }
    }

    /// Returns the CSS media query string for this breakpoint using the provided theme's values.
    /// - Parameter theme: The theme to use for breakpoint values.
    /// - Returns: A CSS media query string.
    @MainActor public func condition(with theme: Theme) -> String {
        let breakpointValue = switch self {
        case .xSmall: theme.siteBreakpoints.xSmall.stringValue
        case .small: theme.siteBreakpoints.small.stringValue
        case .medium: theme.siteBreakpoints.medium.stringValue
        case .large: theme.siteBreakpoints.large.stringValue
        case .xLarge: theme.siteBreakpoints.xLarge.stringValue
        case .xxLarge: theme.siteBreakpoints.xxLarge.stringValue
        }
        return "min-width: \(breakpointValue)"
    }

    /// The raw CSS media query string.
    /// - Note: This property requires theme context. Use `css(for:)` instead.
    public var condition: String {
        preconditionFailure("This query requires theme context. Use css(for:) instead.")
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
    /// - Parameter id: The theme identifier.
    /// - Returns: A theme media query.
    static func theme(_ id: String) -> ThemeQuery {
        ThemeQuery(id)
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
