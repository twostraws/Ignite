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

extension Query {
    /// Converts a Query to a MediaFeature if possible
    var asMediaFeature: MediaFeature? {
        self as? MediaFeature
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

public extension Query where Self == ColorSchemeQuery {
    /// Creates a color scheme media query.
    /// - Parameter scheme: The color scheme to apply.
    /// - Returns: A color scheme media query.
    static func colorScheme(_ scheme: ColorSchemeQuery) -> ColorSchemeQuery {
        scheme
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

public extension Query where Self == DisplayModeQuery {
    /// Creates a display mode media query.
    /// - Parameter mode: The display mode to apply.
    /// - Returns: A display mode media query.
    static func displayMode(_ mode: DisplayModeQuery) -> DisplayModeQuery {
        mode
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

public extension Query where Self == OrientationQuery {
    /// Creates an orientation media query.
    /// - Parameter orientation: The orientation to apply.
    /// - Returns: An orientation media query.
    static func orientation(_ orientation: OrientationQuery) -> OrientationQuery {
        orientation
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

public extension Query where Self == TransparencyQuery {
    /// Creates a transparency preference media query.
    /// - Parameter transparency: The transparency preference to apply.
    /// - Returns: A transparency preference media query.
    static func transparency(_ transparency: TransparencyQuery) -> TransparencyQuery {
        transparency
    }
}
