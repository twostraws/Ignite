//
// MediaFeature.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An internal type used to represent true medai query features during CSS
/// generation, as not all types that conform to `Query` are valid features.
protocol MediaFeature: CustomStringConvertible {
    var description: String { get }
}

extension MediaFeature where Self == ColorSchemeQuery {
    /// Creates a color scheme media feature.
    /// - Parameter scheme: The color scheme to apply.
    /// - Returns: A color scheme media feature.
    static func colorScheme(_ scheme: ColorSchemeQuery) -> ColorSchemeQuery {
        scheme
    }
}

extension MediaFeature where Self == MotionQuery {
    /// Creates a motion preference media feature.
    /// - Parameter motion: The motion preference to apply.
    /// - Returns: A motion preference media feature.
    static func motion(_ motion: MotionQuery) -> MotionQuery {
        motion
    }
}

extension MediaFeature where Self == ContrastQuery {
    /// Creates a contrast preference media feature.
    /// - Parameter contrast: The contrast preference to apply.
    /// - Returns: A contrast preference media feature.
    static func contrast(_ contrast: ContrastQuery) -> ContrastQuery {
        contrast
    }
}

extension MediaFeature where Self == TransparencyQuery {
    /// Creates a transparency preference media feature.
    /// - Parameter transparency: The transparency preference to apply.
    /// - Returns: A transparency preference media feature.
    static func transparency(_ transparency: TransparencyQuery) -> TransparencyQuery {
        transparency
    }
}

extension MediaFeature where Self == OrientationQuery {
    /// Creates an orientation media feature.
    /// - Parameter orientation: The orientation to apply.
    /// - Returns: An orientation media feature.
    static func orientation(_ orientation: OrientationQuery) -> OrientationQuery {
        orientation
    }
}

extension MediaFeature where Self == DisplayModeQuery {
    /// Creates a display mode media feature.
    /// - Parameter mode: The display mode to apply.
    /// - Returns: A display mode media feature.
    static func displayMode(_ mode: DisplayModeQuery) -> DisplayModeQuery {
        mode
    }
}

extension MediaFeature where Self == BreakpointQuery {
    /// Creates a breakpoint media feature.
    /// - Parameter breakpoint: The breakpoint to apply.
    /// - Returns: A breakpoint media feature.
    static func breakpoint(_ breakpoint: BreakpointQuery) -> BreakpointQuery {
        breakpoint
    }
}
