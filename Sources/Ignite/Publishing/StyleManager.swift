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
    static let `default` = StyleManager()

    /// Private initializer to enforce singleton pattern
    private init() {}

    /// Cache of generated CSS class names for styles
    private var classNameCache: [String: String] = [:]

    /// Cache of generated CSS rules for styles
    private var cssRulesCache: [String: String] = [:]

    /// Dictionary of registered styles keyed by their type names
    private var registeredStyles: [String: any Style] = [:]

    /// A structure that holds the default style and all unique style variations for a given `Style`.
    struct StyleMapResult {
        /// The default style attributes that apply when no conditions are met.
        let defaultStyle: [AttributeValue]

        /// A mapping of environment conditions to their corresponding style attributes,
        /// containing only the minimal conditions needed for each unique style variation.
        let uniqueConditions: [EnvironmentConditions: [AttributeValue]]
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
    func generateAllCSS(themes: [Theme]) -> String {
        cssRulesCache.removeAll()

        for (_, style) in registeredStyles {
            generateCSS(for: style, themes: themes)
        }

        return cssRulesCache.values.joined(separator: "\n\n")
    }

    /// Generates a map of all unique style variations and their minimal required conditions.
    /// - Parameters:
    ///   - style: The style to analyze
    ///   - themes: Available themes to consider when generating variations
    /// - Returns: A `StyleMapResult` containing the default style and unique style variations
    private func generateStylesMap(for style: any Style, themes: [Theme]) -> StyleMapResult {
        let collector = StyledHTML()
        var tempMap: [EnvironmentConditions: [AttributeValue]] = [:]

        // Get all possible conditions
        let allConditions = generateAllPossibleEnvironmentConditions(themes: themes)

        // First pass: collect all styles
        for environment in allConditions {
            let styledHTML = style.style(content: collector, environment: environment)
            tempMap[environment] = Array(styledHTML.attributes.styles)
        }

        // Find the default style (when all conditions are nil)
        let defaultEnvironment = EnvironmentConditions()
        let defaultHTML = style.style(content: collector, environment: defaultEnvironment)
        let defaultStyle = Array(defaultHTML.attributes.styles)

        // Second pass: only keep conditions that produce different styles from default
        var uniqueConditions: [EnvironmentConditions: [AttributeValue]] = [:]
        for (environment, styles) in tempMap {
            if styles != defaultStyle {
                // Handle conditions with multiple properties
                if environment.conditionCount > 1 {
                    // Test each property independently to find OR conditions
                    var foundSimpleCondition = false

                    // Test each property in isolation
                    for property in environment.toMediaQueries() {
                        var testCondition = EnvironmentConditions()

                        switch property {
                        case .colorScheme(let value): testCondition.colorScheme = value
                        case .orientation(let value): testCondition.orientation = value
                        case .transparency(let value): testCondition.transparency = value
                        case .displayMode(let value): testCondition.displayMode = value
                        case .motion(let value): testCondition.motion = value
                        case .contrast(let value): testCondition.contrast = value
                        case .theme(let value): testCondition.theme = value
                        case .breakpoint: break
                        }

                        let testResult = style.style(content: collector, environment: testCondition)
                        if Array(testResult.attributes.styles) == styles {
                            uniqueConditions[testCondition] = styles
                            foundSimpleCondition = true
                        }
                    }

                    // If no single property matched, this might be an AND condition
                    if !foundSimpleCondition {
                        // Test if this is a valid AND condition by checking if it produces unique styles
                        let testResult = style.style(content: collector, environment: environment)
                        if Array(testResult.attributes.styles) == styles {
                            // Check if we already have a simpler condition for these styles
                            if let existingCondition = uniqueConditions.first(where: { $0.value == styles })?.key {
                                if environment.conditionCount < existingCondition.conditionCount {
                                    uniqueConditions.removeValue(forKey: existingCondition)
                                    uniqueConditions[environment] = styles
                                }
                            } else {
                                uniqueConditions[environment] = styles
                            }
                        }
                    }
                } else {
                    // Single property condition
                    uniqueConditions[environment] = styles
                }
            }
        }

        return StyleMapResult(
            defaultStyle: defaultStyle,
            uniqueConditions: uniqueConditions
        )
    }

    /// Generates and caches CSS rules for a style
    /// - Parameters:
    ///   - style: The style to generate CSS for
    ///   - themes: Array of themes to generate theme-specific styles for
    private func generateCSS(for style: any Style, themes: [Theme]) {
        let typeName = String(describing: type(of: style))
        var cssRules: OrderedSet<String> = []

        // Get all styles for all possible conditions
        let stylesMap = generateStylesMap(for: style, themes: themes)

        // Generate the default rule
        let rule = """
        .\(className(for: style)) {
            \(stylesMap.defaultStyle.map { "\($0.name): \($0.value)" }.joined(separator: "; "))
        }
        """
        cssRules.append(rule)

        // Generate specific rules for unique conditions
        for (condition, styles) in stylesMap.uniqueConditions {
            let stylesString = styles.map { "\($0.name): \($0.value)" }.joined(separator: ";\n        ")

            if condition.theme != nil && condition.conditionCount > 1 {
                // Combined theme and media query rule
                let mediaQueries = condition.toMediaQueries().filter {
                    if case .theme = $0 { return false }
                    return true
                }
                let mediaConditions = mediaQueries.map { "(\($0.queryString()))" }.joined(separator: " and ")

                let combinedRule = """
                @media \(mediaConditions) {
                    [data-theme-state="\(condition.theme!.kebabCased())"] .\(className(for: style)) {
                        \(stylesString)
                    }
                }
                """
                cssRules.append(combinedRule)
            } else if condition.theme != nil {
                // Theme-only rule
                let themeRule = """
                [data-theme-state="\(condition.theme!.kebabCased())"] .\(className(for: style)) {
                    \(stylesString)
                }
                """
                cssRules.append(themeRule)
            } else {
                // Media query-only rule
                let mediaQueries = condition.toMediaQueries()
                let mediaConditions = mediaQueries.map { "(\($0.queryString()))" }.joined(separator: " and ")

                let mediaRule = """
                @media \(mediaConditions) {
                    .\(className(for: style)) {
                        \(stylesString)
                    }
                }
                """
                cssRules.append(mediaRule)
            }
        }

        cssRulesCache[typeName] = cssRules.joined(separator: "\n\n")
    }

    /// Generates an array of all possible media queries that styles should be tested against.
    /// - Parameter themes: Array of themes to generate theme-specific queries for.
    /// - Returns: An array of all possible `EnvironmentConditions` instances.
    private func generateAllPossibleEnvironmentConditions(themes: [Theme]) -> [EnvironmentConditions] {
        // Define all possible values for each property
        let colorSchemes: [MediaQuery.ColorScheme?] = [nil] + MediaQuery.ColorScheme.allCases.map { Optional($0) }
        let orientations: [MediaQuery.Orientation?] = [nil] + MediaQuery.Orientation.allCases.map { Optional($0) }
        let transparencies: [MediaQuery.Transparency?] = [nil] + MediaQuery.Transparency.allCases.map { Optional($0) }
        let displayModes: [MediaQuery.DisplayMode?] = [nil] + MediaQuery.DisplayMode.allCases.map { Optional($0) }
        let motions: [MediaQuery.Motion?] = [nil] + MediaQuery.Motion.allCases.map { Optional($0) }
        let contrasts: [MediaQuery.Contrast?] = [nil] + MediaQuery.Contrast.allCases.map { Optional($0) }
        let themeIds: [String?] = [nil] + themes.map { $0.id }

        var allConditions: [EnvironmentConditions] = []

        // Generate every possible combination
        for colorScheme in colorSchemes {
            for orientation in orientations {
                for transparency in transparencies {
                    for displayMode in displayModes {
                        for motion in motions {
                            for contrast in contrasts {
                                for themeId in themeIds {
                                    var condition = EnvironmentConditions()
                                    condition.colorScheme = colorScheme
                                    condition.orientation = orientation
                                    condition.transparency = transparency
                                    condition.displayMode = displayMode
                                    condition.motion = motion
                                    condition.contrast = contrast
                                    condition.theme = themeId

                                    allConditions.append(condition)
                                }
                            }
                        }
                    }
                }
            }
        }

        return allConditions
    }

    /// Generates a CSS rule for a specific style and media query
    /// - Parameters:
    ///   - className: The CSS class name to use
    ///   - attributes: The style attributes to apply
    ///   - query: The media query this rule applies to
    /// - Returns: A complete CSS rule string
    private func generateCSSRule(className: String, attributes: CoreAttributes, query: MediaQuery) -> String {
        var selector = ".\(className)"

        // Convert styles to CSS string
        let stylesString = attributes.styles
            .map { "\($0.name): \($0.value)" }
            .joined(separator: "; ")

        // Handle theme-specific case
        if case .theme(let id) = query {
            selector = "[data-theme-state=\"\(id.kebabCased())\"] \(selector)"
            return """
            \(selector) {
                \(stylesString)
            }
            """
        }

        // Handle media query cases
        return """
        @media (\(query.queryString())) {
            \(selector) {
                \(stylesString)
            }
        }
        """
    }
}
