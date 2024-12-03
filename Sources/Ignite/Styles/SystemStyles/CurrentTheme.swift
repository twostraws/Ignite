//
// CurrentTheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A style that applies CSS properties when a specific theme is active.
///
/// CurrentTheme allows you to define styles that only take effect when a particular
/// theme is selected in the application.
public struct CurrentTheme: Style {
    /// The CSS property to modify (e.g., "color", "font-size")
    let property: String

    /// The value to apply to the CSS property
    let value: String

    /// The CSS class name to apply when dark mode is enabled (if using class-based styling)
    let targetClass: String?

    /// The unique identifier of the theme this style targets
    public let themeID: String

    /// Creates a new theme-specific color style.
    /// - Parameters:
    ///   - value: The color value to apply
    ///   - id: The unique identifier of the theme
    init(_ value: String, id: String) {
        self.value = value
        self.property = Property.color.rawValue
        self.themeID = id
        self.targetClass = nil
    }

    /// Creates a new theme-specific style with custom property and value.
    /// - Parameters:
    ///   - property: The CSS property to modify
    ///   - value: The value to apply
    ///   - id: The unique identifier of the theme
    public init(_ property: Property, value: String, id: String) {
        self.property = property.rawValue
        self.value = value
        self.themeID = id
        self.targetClass = nil
    }

    /// Creates a new theme-specific style that applies an existing class.
    public init(class: String, id: String) {
        self.property = ""
        self.value = ""
        self.targetClass = `class`
        self.themeID = id
    }

    /// Resolves the style into a concrete implementation
    public var body: some Style {
        ResolvedStyle(
            property: self.property,
            value: self.value,
            targetClass: self.targetClass,
            selectors: [Selector(conditions: ["[data-theme-state=\"\(self.themeID.kebabCased())\"]"])]
        )
    }
}

public extension Style {
    /// Applies styles that are only active when a specific theme is selected.
    /// - Parameter id: The unique identifier of the theme to target
    /// - Returns: A style that applies its properties only when the specified theme is active
    func currentTheme(id: String) -> some Style {
        let resolvedStyle = (self.body as? ResolvedStyle) ?? ResolvedStyle()

        let themeSelector = Selector(conditions: ["[data-theme-state=\"\(id.kebabCased())\"]"])

        // If there are media queries, we need to combine them with the theme selector
        if !resolvedStyle.mediaQueries.isEmpty {
            return ResolvedStyle(
                property: resolvedStyle.property,
                value: resolvedStyle.value,
                mediaQueries: resolvedStyle.mediaQueries,
                selectors: [themeSelector],
                className: className
            )
        }

        // If no media queries, just use the theme selector
        return ResolvedStyle(
            property: resolvedStyle.property,
            value: resolvedStyle.value,
            selectors: [themeSelector],
            className: className
        )
    }
}

public extension Style {
    func reducedMotion() -> some Style {
        chain(with: "(prefers-reduced-motion: reduce)")
    }
}
