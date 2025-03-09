//
// StyleManager-StyleGeneration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension StyleManager {
    /// Creates a test condition from a single query
    /// - Parameter query: The query to convert into a condition
    /// - Returns: An environment condition with the appropriate property set
    private func createTestCondition(from query: any Query) -> EnvironmentConditions {
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
            testCondition.theme = query.theme
        case let query as BreakpointQuery:
            testCondition.breakpoint = query
        default:
            break
        }

        return testCondition
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
        matchingStyles styles: [InlineStyle],
        using collector: StyledHTML,
        style: any Style
    ) -> EnvironmentConditions? {
        for query in environment.toMediaQueries() {
            let testCondition = createTestCondition(from: query)
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
        styles: [InlineStyle],
        using collector: StyledHTML,
        style: any Style,
        existingConditions uniqueConditions: [EnvironmentConditions: [InlineStyle]]
    ) -> (EnvironmentConditions, [InlineStyle])? {
        let testResult = style.style(content: collector, environment: environment)
        guard Array(testResult.attributes.styles) == styles else { return nil }

        if let existingCondition = uniqueConditions.first(where: { $0.value == styles })?.key {
            return environment.conditionCount < existingCondition.conditionCount
                ? (environment, styles)
                : nil
        }

        return (environment, styles)
    }

    /// Context for processing style variations
    private struct StyleVariationContext {
        let environment: EnvironmentConditions
        let styles: [InlineStyle]
        let collector: StyledHTML
        let style: any Style
        let defaultStyle: [InlineStyle]
    }

    /// Processes a style variation and adds it to the unique conditions map if appropriate
    /// - Parameters:
    ///   - context: The context containing environment, styles, and related data
    ///   - uniqueConditions: The current map of unique conditions
    private func processStyleVariation(
        context: StyleVariationContext,
        uniqueConditions: inout [EnvironmentConditions: [InlineStyle]]
    ) {
        guard context.styles != context.defaultStyle else { return }

        if context.environment.conditionCount > 1 {
            // Try to find a simpler condition first
            if let simpleCondition = analyzeSingleCondition(
                from: context.environment,
                matchingStyles: context.styles,
                using: context.collector,
                style: context.style
            ) {
                uniqueConditions[simpleCondition] = context.styles
            } else if let complexResult = analyzeComplexCondition(
                environment: context.environment,
                styles: context.styles,
                using: context.collector,
                style: context.style,
                existingConditions: uniqueConditions
            ) {
                uniqueConditions[complexResult.0] = complexResult.1
            }
        } else {
            uniqueConditions[context.environment] = context.styles
        }
    }

    /// Collects all style variations for given conditions
    /// - Parameters:
    ///   - style: The style to analyze
    ///   - allConditions: All possible environment conditions
    ///   - collector: The HTML collector
    /// - Returns: A map of environment conditions to their styles
    private func collectStyleVariations(
        for style: any Style,
        conditions allConditions: [EnvironmentConditions],
        using collector: StyledHTML
    ) -> [EnvironmentConditions: [InlineStyle]] {
        var tempMap: [EnvironmentConditions: [InlineStyle]] = [:]

        for environment in allConditions {
            let styledHTML = style.style(content: collector, environment: environment)
            tempMap[environment] = Array(styledHTML.attributes.styles)
        }

        return tempMap
    }

    /// Generates a map of all unique style variations and their minimal required conditions.
    /// - Parameters:
    ///   - style: The style to analyze
    ///   - themes: Available themes to consider when generating variations
    /// - Returns: A `StyleMapResult` containing the default style and unique style variations
    private func generateStylesMap(for style: any Style, themes: [any Theme]) -> StyleMapResult {
        let collector = StyledHTML()
        var uniqueConditions: [EnvironmentConditions: [InlineStyle]] = [:]

        // Get all possible conditions and collect styles
        let allConditions = generateAllPossibleEnvironmentConditions(themes: themes)
        let tempMap = collectStyleVariations(for: style, conditions: allConditions, using: collector)

        // Find the default style
        let defaultEnvironment = EnvironmentConditions()
        let defaultHTML = style.style(content: collector, environment: defaultEnvironment)
        let defaultStyle = Array(defaultHTML.attributes.styles)

        // Analyze conditions that produce different styles from default
        for (environment, styles) in tempMap {
            let context = StyleVariationContext(
                environment: environment,
                styles: styles,
                collector: collector,
                style: style,
                defaultStyle: defaultStyle
            )
            processStyleVariation(
                context: context,
                uniqueConditions: &uniqueConditions
            )
        }

        return StyleMapResult(
            defaultStyle: defaultStyle,
            uniqueConditions: uniqueConditions
        )
    }

    /// Converts queries to media features with proper theme handling
    /// - Parameters:
    ///   - mediaQueries: Array of queries to convert
    ///   - themes: Available themes
    ///   - condition: The environment condition
    /// - Returns: Array of media features
    private func convertToMediaFeatures(
        from mediaQueries: [any Query],
        themes: [any Theme],
        condition: EnvironmentConditions
    ) -> [MediaFeature] {
        mediaQueries.compactMap { query -> MediaFeature? in
            if let breakpointQuery = query as? BreakpointQuery {
                // If we have a theme, use its breakpoint values
                if let theme = condition.theme.flatMap({ targetTheme in
                    themes.first { $0.cssID.starts(with: targetTheme.idPrefix) }
                }) {
                    // Create a new breakpoint query with theme-specific values
                    return breakpointQuery.withTheme(theme).asMediaFeature
                }
                // If no theme specified, use default theme's values
                return breakpointQuery.asMediaFeature
            }
            return query.asMediaFeature
        }
    }

    /// Generates a CSS rule for a specific condition and style
    /// - Parameters:
    ///   - condition: The environment condition
    ///   - styles: The styles to apply
    ///   - className: The CSS class name
    ///   - mediaQueries: The media queries to apply
    ///   - themes: Available themes
    /// - Returns: The generated CSS rule
    private func generateCSSRule(
        for condition: EnvironmentConditions,
        styles: [InlineStyle],
        className: String,
        mediaQueries: [any Query],
        themes: [any Theme]
    ) -> String {
        let ruleset = Ruleset(.class(className), styles: styles)

        if let theme = condition.theme, condition.conditionCount > 1 {
            // Combined theme and media query rule
            let mediaFeatures = convertToMediaFeatures(
                from: mediaQueries,
                themes: themes,
                condition: condition
            )

            let mediaQuery = MediaQuery(mediaFeatures) {
                Ruleset(
                    [.attribute(name: "data-bs-theme^", value: theme.idPrefix),
                     .class(className)],
                    styles: styles
                )
            }
            return mediaQuery.description
        } else if let theme = condition.theme {
            // Theme-only rule
            let themeRuleset = Ruleset(
                [.attribute(name: "data-bs-theme^", value: theme.idPrefix),
                 .class(className)],
                styles: styles
            )
            return themeRuleset.description
        } else if !mediaQueries.isEmpty {
            // Media query-only rule
            let mediaFeatures = convertToMediaFeatures(
                from: mediaQueries,
                themes: themes,
                condition: condition
            )

            let mediaQuery = MediaQuery(mediaFeatures) {
                [ruleset]
            }
            return mediaQuery.description
        } else {
            return ruleset.description
        }
    }

    /// Generates and caches CSS rules for a style
    /// - Parameters:
    ///   - style: The style to generate CSS for
    ///   - themes: Array of themes to generate theme-specific styles for
    func generateCSS(for style: any Style, themes: [any Theme]) {
        let typeName = String(describing: type(of: style))
        var cssRules: OrderedSet<String> = []

        // Get all styles for all possible conditions
        let stylesMap = generateStylesMap(for: style, themes: themes)

        // Generate the default rule
        let defaultRuleset = Ruleset(.class(className(for: style)), styles: stylesMap.defaultStyle)
        cssRules.append(defaultRuleset.description)

        // Generate specific rules for unique conditions
        for (condition, styles) in stylesMap.uniqueConditions {
            let mediaQueries: [any Query] = condition.toMediaQueries().filter {
                if $0 is ThemeQuery { return false }
                return true
            }

            let rule = generateCSSRule(
                for: condition,
                styles: styles,
                className: className(for: style),
                mediaQueries: mediaQueries,
                themes: themes
            )
            cssRules.append(rule)
        }

        cssRulesCache[typeName] = cssRules.joined(separator: "\n\n")
    }

    /// Generates an array of all possible media queries that styles should be tested against.
    /// - Parameter themes: Array of themes to generate theme-specific queries for.
    /// - Returns: An array of all possible `EnvironmentConditions` instances.
    private func generateAllPossibleEnvironmentConditions(themes: [any Theme]) -> [EnvironmentConditions] {
        // Define all possible values for each property
        let colorSchemes: [ColorSchemeQuery?] = [nil] + ColorSchemeQuery.allCases.map { Optional($0) }
        let orientations: [OrientationQuery?] = [nil] + OrientationQuery.allCases.map { Optional($0) }
        let transparencies: [TransparencyQuery?] = [nil] + TransparencyQuery.allCases.map { Optional($0) }
        let displayModes: [DisplayModeQuery?] = [nil] + DisplayModeQuery.allCases.map { Optional($0) }
        let motions: [MotionQuery?] = [nil] + MotionQuery.allCases.map { Optional($0) }
        let contrasts: [ContrastQuery?] = [nil] + ContrastQuery.allCases.map { Optional($0) }
        let breakpoints: [BreakpointQuery?] = [nil] + BreakpointQuery.allCases.map { Optional($0) }
        let themes: [(any Theme.Type)?] = [nil] + themes.map { type(of: $0) }

        var allConditions: [EnvironmentConditions] = []

        // Generate every possible combination
        for colorScheme in colorSchemes {
            for orientation in orientations {
                for transparency in transparencies {
                    for displayMode in displayModes {
                        for motion in motions {
                            for contrast in contrasts {
                                for themeID in themes {
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
