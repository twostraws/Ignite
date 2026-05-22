//
// CSSManager.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A manager that generates and maintains CSS classes for media query-based styling rules.
final class CSSManager {
    /// The manager for the current publish operation.
    static var shared: CSSManager {
        PublishingContext.shared.cssManager
    }

    /// Queue of registrations waiting to be processed
    private struct PendingRegistration {
        let queries: [any Query]
        let styles: [InlineStyle]
        let className: String
    }

    private var pendingRegistrations: [PendingRegistration] = []

    /// A mapping of query hashes to their generated CSS rules.
    private var rules: [String] = []

    /// Custom fonts that need to be included in the CSS output
    var customFonts: OrderedSet<Font> = []

    /// Registers a custom font for use in the CSS output
    func registerFontFamily(_ font: Font) {
        customFonts.append(font)
    }

    /// Processes all registrations
    /// - Parameter themes: Array of themes from the site.
    /// - Returns: A string containing all generated CSS rules, separated by newlines.
    func generateAllRules(themes: [any Theme]) -> String {
        let themes = themes.filter { !($0 is AutoTheme) }
        // Process all registrations
        for registration in pendingRegistrations {
            let rule = generateCSSRule(
                for: registration.queries,
                className: registration.className,
                styles: registration.styles,
                themes: themes)
            rules.append(rule)
        }

        return rules.joined(separator: "\n\n")
    }

    /// Registers a set of media queries and queues them for CSS generation
    /// - Parameters:
    ///   - values: ResponsiveValues containing boolean values for each breakpoint
    /// - Returns: The class name that will be used for these styles
    func registerStyles(_ values: ResponsiveValues<Bool>) -> String {
        let className = Self.className(forStyles: values)
        registerStyles(values, className: className)
        return className
    }

    /// Returns the class name used for a set of media-query styles.
    static func className(forStyles values: ResponsiveValues<Bool>) -> String {
        "style-" + values.values.description.truncatedHash
    }

    /// Registers a set of media queries and queues them for CSS generation.
    private func registerStyles(_ values: ResponsiveValues<Bool>, className: String) {
        let values = values.values
        let baseValue = values[.xSmall]
        let breakpointValues = values.filter { $0.key != .xSmall }

        if let baseValue {
            appendPendingRegistration(.init(
                queries: [],
                styles: [.init(.display, value: baseValue ? "none" : "unset")],
                className: className))
        }

        for (breakpoint, value) in breakpointValues {
            appendPendingRegistration(.init(
                queries: [.breakpoint(.init(breakpoint)!)],
                styles: [.init(.display, value: value ? "none" : "unset")],
                className: className))
        }
    }

    /// Registers CSS classes for responsive font sizes and returns the generated class name.
    /// - Parameter responsiveSize: The responsive font size.
    /// - Returns: A unique class name that applies the font's responsive size rules.
    func registerFont(_ responsiveSize: ResponsiveValues<LengthUnit>) -> String {
        let className = Self.className(forFont: responsiveSize)
        registerFont(responsiveSize, className: className)
        return className
    }

    /// Returns the class name used for a responsive font size.
    static func className(forFont responsiveSize: ResponsiveValues<LengthUnit>) -> String {
        "font-" + responsiveSize.values.description.truncatedHash
    }

    /// Registers CSS classes for responsive font sizes.
    private func registerFont(_ responsiveSize: ResponsiveValues<LengthUnit>, className: String) {
        let values = responsiveSize.values
        let baseSize = values[.xSmall]
        let breakpointSizes = values.filter { $0.key != .xSmall }

        if let baseSize {
            appendPendingRegistration(.init(
                queries: [],
                styles: [.init(.fontSize, value: baseSize.stringValue)],
                className: className))
        }

        for (breakpoint, size) in breakpointSizes {
            appendPendingRegistration(.init(
                queries: [.breakpoint(.init(breakpoint)!)],
                styles: [.init(.fontSize, value: size.stringValue)],
                className: className))
        }
    }

    /// Queues a pending registration if it has not already been queued.
    private func appendPendingRegistration(_ registration: PendingRegistration) {
        let isDuplicate = pendingRegistrations.contains { existing in
            existing.className == registration.className &&
            existing.styles == registration.styles &&
            existing.queries.map(\.condition) == registration.queries.map(\.condition)
        }

        if isDuplicate == false {
            pendingRegistrations.append(registration)
        }
    }

    /// Generates a CSS rule for a set of media queries and properties.
    /// - Parameters:
    ///   - queries: The media queries to apply.
    ///   - className: The CSS class name to use.
    ///   - properties: The CSS properties to apply.
    ///   - themes: The themes to handle.
    /// - Returns: A CSS rule string.
    private func generateCSSRule(
        for queries: [any Query],
        className: String,
        styles: [InlineStyle],
        themes: [any Theme]
    ) -> String {
        var rules: [String] = []

        // Only generate base rule if there are no queries
        if queries.isEmpty {
            let baseRule = generateBaseRule(className: className, styles: styles)
            rules.append(baseRule)
        } else {
            // Generate media query rules for each theme
            for theme in themes {
                let themedRule = generateThemedRule(
                    for: queries,
                    className: className,
                    styles: styles,
                    theme: theme,
                    supportsMultipleThemes: themes.count > 1)
                rules.append(themedRule)
            }
        }

        return rules.joined(separator: "\n\n")
    }

    /// Generates a base CSS rule without theme context
    /// - Parameters:
    ///   - className: The CSS class name to use
    ///   - styles: The CSS properties to apply
    /// - Returns: A CSS rule string
    private func generateBaseRule(className: String, styles: [InlineStyle]) -> String {
        let styleRules = styles.map { "\($0.property): \($0.value);" }.joined(separator: " ")
        return """
        .\(className) {
            \(styleRules)
        }
        """
    }

    /// Generates a themed CSS rule for a specific theme
    /// - Parameters:
    ///   - queries: The media queries to apply
    ///   - className: The CSS class name to use
    ///   - styles: The CSS styles to apply
    ///   - theme: The theme context for this rule
    ///   - supportsMultipleThemes: Whether your site has more than one theme.
    /// - Returns: A CSS rule string with theme context
    private func generateThemedRule(
        for queries: [any Query],
        className: String,
        styles: [InlineStyle],
        theme: any Theme,
        supportsMultipleThemes: Bool
    ) -> String {
        let (_, mediaQueries) = queries.reduce(into: (Set<String>(), [String]())) { result, query in
            if let themeQuery = query as? ThemeQuery {
                result.0.insert(themeQuery.theme.idPrefix)
            } else if let breakpointQuery = query as? BreakpointQuery {
                result.1.append(breakpointQuery.withTheme(theme).condition)
            } else {
                result.1.append(query.condition)
            }
        }

        let selector = supportsMultipleThemes ? "[data-bs-theme=\"\(theme.cssID)\"] " : ""
        let styleRules = styles.map { "\($0.property): \($0.value);" }.joined(separator: " ")

        if mediaQueries.isEmpty {
            return """
            @media (prefers-color-scheme: \(theme.name)) {
                \(selector).\(className) {
                    \(styleRules)
                }
            }
            """
        } else {
            return """
            @media (\(mediaQueries.joined(separator: ") and ("))) {
                \(selector).\(className) {
                    \(styleRules)
                }
            }
            """
        }
    }
}
