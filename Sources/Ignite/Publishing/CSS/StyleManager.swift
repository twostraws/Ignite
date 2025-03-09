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

    /// Cache of generated CSS rules for styles
    var cssRulesCache: [String: String] = [:]

    /// Cache of generated CSS class names for styles
    private var classNameCache: [String: String] = [:]

    /// Dictionary of registered styles keyed by their type names
    private var registeredStyles: [String: any Style] = [:]

    /// A structure that holds the default style and all unique style variations for a given `Style`.
    struct StyleMapResult {
        /// The default style attributes that apply when no conditions are met.
        let defaultStyle: [InlineStyle]

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
        let defaultStyle: [InlineStyle]
    }

    /// Gets or generates a CSS class name for a style
    /// - Parameter style: The style to get a class name for
    /// - Returns: The CSS class name for this style
    func className(for style: any Style) -> String {
        let typeName = String(describing: type(of: style))

        if let cached = classNameCache[typeName] {
            return cached
        }

        let baseName = typeName.hasSuffix("Style") ? typeName : typeName + "Style"
        let className = baseName.kebabCased()
        classNameCache[typeName] = className

        return className
    }

    /// Registers a style for CSS generation
    /// - Parameter style: The style to register
    func registerStyle(_ style: any Style) {
        let typeName = String(describing: type(of: style))
        registeredStyles[typeName] = style
    }

    /// Generates CSS for all registered styles using the provided themes
    /// - Parameter themes: Array of themes to generate theme-specific styles for
    /// - Returns: Complete CSS string for all styles
    func generateAllCSS(themes: [any Theme]) -> String {
        cssRulesCache.removeAll()

        for (_, style) in registeredStyles {
            generateCSS(for: style, themes: themes)
        }

        return cssRulesCache.values.joined(separator: "\n\n")
    }
}
