//
// Hidden.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Optionally hides the view in the view hierarchy.
    /// - Parameter isHidden: Whether to hide this element or not.
    /// - Returns: A modified copy of the element with visibility applied.
    func hidden(_ isHidden: Bool = true) -> some HTML {
        self.class(isHidden ? "d-none" : nil)
    }

    /// Hides the element when all specified media queries match.
    /// - Parameter visibility: One or more media queries that must all match for the element to be hidden.
    /// - Returns: A modified copy of the element with conditional visibility.
    func hidden(_ visibility: ResponsiveBoolean) -> some HTML {
        let manager = CSSManager.shared
        let visibilityValues = visibility.values
        let className = manager.registerStyles(visibilityValues)
        return self.class(className)
    }
}

public extension NavigationElement {
    /// Hides the element when all specified media queries match.
    /// - Parameter queries: One or more media queries that must all match for the element to be hidden.
    /// - Returns: A modified copy of the element with conditional visibility.
    func hidden(_ visibility: ResponsiveBoolean) -> Self {
        let manager = CSSManager.shared
        let visibilityValues = visibility.values
        let className = manager.registerStyles(visibilityValues)
        var copy = self
        copy.attributes.append(classes: className)
        return copy
    }
}

public extension StyledHTML {
    /// Hides the view in the view hierarchy.
    func hidden() -> Self {
        self.style(.display, "none")
    }
}

/// A type that provides responsive boolean values across different screen sizes.
public struct ResponsiveBoolean: Sendable {
    let values: ResponsiveValues<Bool>
    /// Creates a responsive value that adapts across different screen sizes.
    /// - Parameters:
    ///   - xSmall: The base value, applied to all breakpoints unless overridden.
    ///   - small: Value for small screens and up. If `nil`, inherits from smaller breakpoints.
    ///   - medium: Value for medium screens and up. If `nil`, inherits from smaller breakpoints.
    ///   - large: Value for large screens and up. If `nil`, inherits from smaller breakpoints.
    ///   - xLarge: Value for extra large screens and up. If `nil`, inherits from smaller breakpoints.
    ///   - xxLarge: Value for extra extra large screens and up. If `nil`, inherits from smaller breakpoints.
    /// - Returns: A responsive alignment that adapts to different screen sizes.
    public static func responsive(
        _ xSmall: Bool? = nil,
        small: Bool? = nil,
        medium: Bool? = nil,
        large: Bool? = nil,
        xLarge: Bool? = nil,
        xxLarge: Bool? = nil
    ) -> Self {
        ResponsiveBoolean(
            values: ResponsiveValues(
                xSmall,
                small: small,
                medium: medium,
                large: large,
                xLarge: xLarge,
                xxLarge: xxLarge
            )
        )
    }
}
