//
// Style.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines a style that can be resolved based on environment conditions.
/// Styles are used to create reusable visual treatments that can adapt based on media queries
/// and theme settings.
///
/// Example:
/// ```swift
/// struct MyCustomStyle: Style {
///     func style(content: StyledHTML, environment: EnvironmentConditions) -> StyledHTML {
///         if environment.colorScheme == .dark {
///             content.foregroundStyle(.red)
///         } else {
///             content.foregroundStyle(.blue)
///         }
///     }
/// }
/// ```

public protocol Style: Hashable {
    /// Resolves the style for the given HTML content and environment conditions
    /// - Parameters:
    ///   - content: An HTML element to apply styles to
    ///   - environmentConditions: The current media query condition to resolve against
    /// - Returns: A modified HTML element with the appropriate styles applied
    func style(content: StyledHTML, environment: EnvironmentConditions) -> StyledHTML
}

extension Style {
    /// The name of the CSS class this `Style` generates,
    /// derived from the type name minus the "Style" suffix, if present.
    @MainActor var className: String {
        let typeName = String(describing: type(of: style))
        let baseName = typeName.hasSuffix("Style") ? typeName : typeName + "Style"
        let className = baseName.kebabCased()
        return className
    }
}
