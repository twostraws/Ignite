//
// EnvironmentConditions.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that represents a combination of environment conditions for styling content.
///
/// Use `EnvironmentConditions` to define how content should be styled based on various
/// device and user preferences. For example:
///
/// ```swift
/// struct MyStyle: Style {
///     func style(content: StyledHTML, environment: EnvironmentConditions) -> StyledHTML {
///         if environment.colorScheme == .dark && environment.orientation == .portrait {
///             content.foregroundStyle(.red)
///         } else {
///             content
///         }
///     }
/// }
/// ```
public struct EnvironmentConditions: Equatable, Hashable, Sendable {
    /// The user's preferred color scheme.
    public var colorScheme: ColorSchemeQuery?

    /// The user's preferred motion settings.
    public var motion: MotionQuery?

    /// The user's preferred contrast settings.
    public var contrast: ContrastQuery?

    /// The user's preferred transparency settings.
    public var transparency: TransparencyQuery?

    /// The device's current orientation.
    public var orientation: OrientationQuery?

    /// The web application's display mode.
    public var displayMode: DisplayModeQuery?

    /// The current breakpoint query.
    public var breakpoint: BreakpointQuery?

    /// The current theme identifier.
    public var theme: (any Theme.Type)?

    /// Creates a new environment conditions instance.
    /// - Parameters:
    ///   - colorScheme: The preferred color scheme
    ///   - motion: The preferred motion settings
    ///   - contrast: The preferred contrast settings
    ///   - transparency: The preferred transparency settings
    ///   - orientation: The device orientation
    ///   - displayMode: The display mode
    ///   - breakpoint: The breakpoint query
    ///   - theme: The theme identifier
    init(
        colorScheme: ColorSchemeQuery? = nil,
        motion: MotionQuery? = nil,
        contrast: ContrastQuery? = nil,
        transparency: TransparencyQuery? = nil,
        orientation: OrientationQuery? = nil,
        displayMode: DisplayModeQuery? = nil,
        breakpoint: BreakpointQuery? = nil,
        theme: (any Theme.Type)? = nil
    ) {
        self.colorScheme = colorScheme
        self.motion = motion
        self.contrast = contrast
        self.transparency = transparency
        self.orientation = orientation
        self.displayMode = displayMode
        self.breakpoint = breakpoint
        self.theme = theme
    }

    /// Converts the environment conditions to an array of media queries.
    /// - Returns: An array of ``Query`` values representing the active conditions.
    func toMediaQueries() -> [any Query] {
        var queries: [any Query] = []
        if let colorScheme { queries.append(.colorScheme(colorScheme)) }
        if let motion { queries.append(.motion(motion)) }
        if let contrast { queries.append(.contrast(contrast)) }
        if let transparency { queries.append(.transparency(transparency)) }
        if let orientation { queries.append(.orientation(orientation)) }
        if let displayMode { queries.append(.displayMode(displayMode)) }
        if let theme { queries.append(.theme(theme)) }
        if let breakpoint { queries.append(.breakpoint(breakpoint)) }
        return queries
    }

    var conditionCount: Int {
        var count = 0
        if colorScheme != nil { count += 1 }
        if orientation != nil { count += 1 }
        if transparency != nil { count += 1 }
        if displayMode != nil { count += 1 }
        if motion != nil { count += 1 }
        if contrast != nil { count += 1 }
        if breakpoint != nil { count += 1 }
        if theme != nil { count += 1 }
        return count
    }

    public static func == (lhs: EnvironmentConditions, rhs: EnvironmentConditions) -> Bool {
        lhs.colorScheme == rhs.colorScheme &&
        lhs.motion == rhs.motion &&
        lhs.contrast == rhs.contrast &&
        lhs.transparency == rhs.transparency &&
        lhs.orientation == rhs.orientation &&
        lhs.displayMode == rhs.displayMode &&
        lhs.breakpoint == rhs.breakpoint &&
        lhs.theme == rhs.theme
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(colorScheme)
        hasher.combine(motion)
        hasher.combine(contrast)
        hasher.combine(transparency)
        hasher.combine(orientation)
        hasher.combine(displayMode)
        hasher.combine(breakpoint)
        if let theme = theme {
            hasher.combine(theme.idPrefix)
        }
    }
}
