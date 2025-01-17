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

    /// Analyzes a single environment condition to determine if it produces unique styles.
    /// - Parameters:
    ///   - environment: The environment condition to test
    ///   - styles: The target styles to match
    ///   - collector: The HTML collector for style testing
    ///   - style: The style to analyze
    /// - Returns: The environment condition if it produces matching styles, nil otherwise
    private func analyzeSingleCondition(
        from environment: EnvironmentConditions,
        matchingStyles styles: [AttributeValue],
        using collector: StyledHTML,
        style: any Style
    ) -> EnvironmentConditions? {
        for query in environment.toMediaQueries() {
            var testCondition = EnvironmentConditions()

            switch query {
            case let query as ColorSchemeQuery:
                testCondition.colorScheme = query
            case let query as OrientationQuery:
                testCondition.orientation = query
            case let query as TransparencyQuery:
                testCondition.transparency = query
            case let query as DisplayModeQuery:
                testCondition.displayMode = query
            case let query as MotionQuery:
                testCondition.motion = query
            case let query as ContrastQuery:
                testCondition.contrast = query
            case let query as ThemeQuery:
                testCondition.theme = query.id
            case let query as BreakpointQuery:
                testCondition.breakpoint = query
            default:
                break
            }

            let testResult = style.style(content: collector, environment: testCondition)
            if Array(testResult.attributes.styles) == styles {
                return testCondition
            }
        }
        return nil
    }

    /// Analyzes complex environment conditions with multiple properties.
    /// - Parameters:
    ///   - environment: The environment condition to analyze
    ///   - styles: The target styles to match
    ///   - collector: The HTML collector for style testing
    ///   - style: The style to analyze
    ///   - uniqueConditions: Existing unique conditions map
    /// - Returns: A tuple containing the condition and styles if valid
    private func analyzeComplexCondition(
        environment: EnvironmentConditions,
        styles: [AttributeValue],
        using collector: StyledHTML,
        style: any Style,
        existingConditions uniqueConditions: [EnvironmentConditions: [AttributeValue]]
    ) -> (EnvironmentConditions, [AttributeValue])? {
        let testResult = style.style(content: collector, environment: environment)
        guard Array(testResult.attributes.styles) == styles else { return nil }

        if let existingCondition = uniqueConditions.first(where: { $0.value == styles })?.key {
            return environment.conditionCount < existingCondition.conditionCount
                ? (environment, styles)
                : nil
        }

        return (environment, styles)
    }

    /// Generates a map of all unique style variations and their minimal required conditions.
    /// - Parameters:
    ///   - style: The style to analyze
    ///   - themes: Available themes to consider when generating variations
    /// - Returns: A `StyleMapResult` containing the default style and unique style variations
    private func generateStylesMap(for style: any Style, themes: [Theme]) -> StyleMapResult {
        let collector = StyledHTML()
        var tempMap: [EnvironmentConditions: [AttributeValue]] = [:]
        var uniqueConditions: [EnvironmentConditions: [AttributeValue]] = [:]

        // Get all possible conditions and collect styles
        let allConditions = generateAllPossibleEnvironmentConditions(themes: themes)
        for environment in allConditions {
            let styledHTML = style.style(content: collector, environment: environment)
            tempMap[environment] = Array(styledHTML.attributes.styles)
        }

        // Find the default style
        let defaultEnvironment = EnvironmentConditions()
        let defaultHTML = style.style(content: collector, environment: defaultEnvironment)
        let defaultStyle = Array(defaultHTML.attributes.styles)

        // Analyze conditions that produce different styles from default
        for (environment, styles) in tempMap where styles != defaultStyle {
            if environment.conditionCount > 1 {
                // Try to find a simpler condition first
                if let simpleCondition = analyzeSingleCondition(
                    from: environment,
                    matchingStyles: styles,
                    using: collector,
                    style: style
                ) {
                    uniqueConditions[simpleCondition] = styles
                } else if let complexResult = analyzeComplexCondition(
                    environment: environment,
                    styles: styles,
                    using: collector,
                    style: style,
                    existingConditions: uniqueConditions
                ) {
                    uniqueConditions[complexResult.0] = complexResult.1
                }
            } else {
                uniqueConditions[environment] = styles
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

            let mediaQueries: [any Query] = condition.toMediaQueries().filter {
                if $0 is ThemeQuery { return false }
                return true
            }

            // Process media queries, handling breakpoints specially
            let mediaConditions = mediaQueries.map { query in
                if let breakpointQuery = query as? BreakpointQuery {
                    // If we have a theme, use its breakpoint values
                    if let theme = themes.first(where: { $0.id == condition.theme }) {
                        return "(\(breakpointQuery.condition(with: theme)))"
                    }
                    // If no theme specified, use default theme's values
                    return "(\(breakpointQuery.condition(with: themes[0])))"
                }
                return "(\(query.condition))"
            }.joined(separator: " and ")

            if condition.theme != nil, condition.conditionCount > 1 {
                // Combined theme and media query rule
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
        let colorSchemes: [ColorSchemeQuery?] = [nil] + ColorSchemeQuery.allCases.map { Optional($0) }
        let orientations: [OrientationQuery?] = [nil] + OrientationQuery.allCases.map { Optional($0) }
        let transparencies: [TransparencyQuery?] = [nil] + TransparencyQuery.allCases.map { Optional($0) }
        let displayModes: [DisplayModeQuery?] = [nil] + DisplayModeQuery.allCases.map { Optional($0) }
        let motions: [MotionQuery?] = [nil] + MotionQuery.allCases.map { Optional($0) }
        let contrasts: [ContrastQuery?] = [nil] + ContrastQuery.allCases.map { Optional($0) }
        let breakpoints: [BreakpointQuery?] = [nil] + BreakpointQuery.allCases.map { Optional($0) }
        let themeIDs: [String?] = [nil] + themes.map { $0.id }

        var allConditions: [EnvironmentConditions] = []

        // Generate every possible combination
        for colorScheme in colorSchemes {
            for orientation in orientations {
                for transparency in transparencies {
                    for displayMode in displayModes {
                        for motion in motions {
                            for contrast in contrasts {
                                for themeID in themeIDs {
                                    for breakpoint in breakpoints {
                                        var condition = EnvironmentConditions()
                                        condition.colorScheme = colorScheme
                                        condition.orientation = orientation
                                        condition.transparency = transparency
                                        condition.displayMode = displayMode
                                        condition.motion = motion
                                        condition.contrast = contrast
                                        condition.theme = themeID
                                        condition.breakpoint = breakpoint

                                        allConditions.append(condition)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        return allConditions
    }
}
