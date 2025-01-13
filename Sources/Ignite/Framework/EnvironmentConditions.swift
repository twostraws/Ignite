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
///             content.style(.color, "red")
///         } else {
///             content
///         }
///     }
/// }
/// ```
public struct EnvironmentConditions: Equatable, Hashable, Sendable {
    /// The user's preferred color scheme.
    public var colorScheme: MediaQuery.ColorScheme?

    /// The user's preferred motion settings.
    public var motion: MediaQuery.Motion?

    /// The user's preferred contrast settings.
    public var contrast: MediaQuery.Contrast?

    /// The user's preferred transparency settings.
    public var transparency: MediaQuery.Transparency?

    /// The device's current orientation.
    public var orientation: MediaQuery.Orientation?

    /// The web application's display mode.
    public var displayMode: MediaQuery.DisplayMode?

    /// The current theme identifier.
    public var theme: String?

    /// Creates a new environment conditions instance.
    /// - Parameters:
    ///   - colorScheme: The preferred color scheme
    ///   - motion: The preferred motion settings
    ///   - contrast: The preferred contrast settings
    ///   - transparency: The preferred transparency settings
    ///   - orientation: The device orientation
    ///   - displayMode: The display mode
    ///   - theme: The theme identifier
    init(
        colorScheme: MediaQuery.ColorScheme? = nil,
        motion: MediaQuery.Motion? = nil,
        contrast: MediaQuery.Contrast? = nil,
        transparency: MediaQuery.Transparency? = nil,
        orientation: MediaQuery.Orientation? = nil,
        displayMode: MediaQuery.DisplayMode? = nil,
        theme: String? = nil
    ) {
        self.colorScheme = colorScheme
        self.motion = motion
        self.contrast = contrast
        self.transparency = transparency
        self.orientation = orientation
        self.displayMode = displayMode
        self.theme = theme
    }

    /// Converts the environment conditions to an array of media queries.
    /// - Returns: An array of ``MediaQuery`` values representing the active conditions.
    func toMediaQueries() -> [MediaQuery] {
        var queries: [MediaQuery] = []
        if let colorScheme { queries.append(.colorScheme(colorScheme)) }
        if let motion { queries.append(.motion(motion)) }
        if let contrast { queries.append(.contrast(contrast)) }
        if let transparency { queries.append(.transparency(transparency)) }
        if let orientation { queries.append(.orientation(orientation)) }
        if let displayMode { queries.append(.displayMode(displayMode)) }
        if let theme { queries.append(.theme(theme)) }
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
        if theme != nil { count += 1 }
        return count
    }
}
