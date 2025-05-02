//
// StyleManager.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A manager responsible for generating and maintaining CSS classes from Style implementations.
/// This class handles style caching, CSS generation, and integration with the publishing process.
@MainActor
final class StyleManager {
    /// The shared instance used for managing styles across the application
    static let shared = StyleManager()

    // Private initializer to enforce singleton pattern
    private init() {}

    /// Dictionary of registered styles keyed by their type names
    private var registeredStyles = [any Style]()

    /// A structure that holds the default style and all unique style variations for a given `Style`.
    struct StyleMapResult {
        /// The default style attributes that apply when no conditions are met.
        let defaultStyles: [InlineStyle]

        /// A mapping of environment conditions to their corresponding style attributes,
        /// containing only the minimal conditions needed for each unique style variation.
        let uniqueConditions: [EnvironmentConditions: [InlineStyle]]
    }

    /// Context for processing style variations
    private struct StyleVariationContext {
        let environment: EnvironmentConditions
        let styles: [InlineStyle]
        let collector: StyledHTML
        let style: any Style
        let defaultStyles: [InlineStyle]
    }

    /// Registers a style for CSS generation
    /// - Parameter style: The style to register
    func registerStyle(_ style: any Style) {
        registeredStyles.append(style)
    }

    /// Generates CSS for all registered styles using the provided themes
    /// - Parameter themes: Array of themes to generate theme-specific styles for
    /// - Returns: Complete CSS string for all styles
    func generateAllCSS(themes: [any Theme]) -> String {
        let cssRules = registeredStyles.map { style in
            generateCSS(style: style, themes: themes)
        }

        return cssRules.joined(separator: "\n\n")
    }
}
