//
// CSSManager.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A manager that generates and maintains CSS classes for media query-based styling rules.
@MainActor
final class CSSManager {
    /// The shared instance used for managing CSS rules across the application.
    static let shared = CSSManager()

    /// Queue of registrations waiting to be processed
    private struct PendingRegistration {
        let queries: [any Query]
        let properties: [InlineStyle]
        let className: String?
    }

    private var pendingRegistrations: [PendingRegistration] = []

    /// A mapping of query hashes to their corresponding CSS class names.
    private var classNames: [String: String] = [:]

    /// A mapping of query hashes to their generated CSS rules.
    private var rules: [String: String] = [:]

    /// A mapping of query hashes to their style properties.
    private var styleProperties: [String: [InlineStyle]] = [:]

    /// Custom fonts that need to be included in the CSS output
    var customFonts: [Font] = []

    /// Registers a custom font for use in the CSS output
    func registerFont(_ font: Font) {
        customFonts.append(font)
    }

    /// Processes all registrations
    /// - Parameter themes: Array of themes from the site.
    /// - Returns: A string containing all generated CSS rules, separated by newlines.
    func generateAllRules(themes: [any Theme]) -> String {
        rules.removeAll()
        classNames.removeAll()
        styleProperties.removeAll()
        let themes = themes.filter { !($0 is AutoTheme) }

        // Process all registrations
        for registration in pendingRegistrations {
            let hash = hashForQueries(registration.queries)
            let finalClassName = registration.className ?? "style-\(hash)"

            classNames[hash] = finalClassName
            styleProperties[hash] = registration.properties
            rules[hash] = generateCSSRule(
                for: registration.queries,
                className: finalClassName,
                properties: registration.properties,
                themes: themes
            )
        }

        return rules.values.joined(separator: "\n\n")
    }

    /// Registers a set of media queries and queues them for CSS generation
    /// - Parameters:
    ///   - queries: Media queries that determine when styles should be applied
    ///   - properties: CSS property names and values to apply
    ///   - className: Optional specific class name to use (generates one if nil)
    /// - Returns: The class name that will be used for these styles
    @discardableResult
    func register(
        _ queries: [any Query] = [],
        properties: [InlineStyle] = [.init(.display, value: "none")],
        className: String? = nil
    ) -> String {
        let hash = hashForQueries(queries)
        let finalClassName = className ?? "style-\(hash)"

        pendingRegistrations.append(PendingRegistration(
            queries: queries,
            properties: properties,
            className: finalClassName
        ))

        return finalClassName
    }

    /// Gets the class name for a set of media queries.
    /// - Parameter queries: The media queries to look up.
    /// - Returns: The corresponding CSS class name, or an empty string if not found.
    func className(for queries: [any Query]) -> String {
        let hash = hashForQueries(queries)
        return classNames[hash] ?? ""
    }

    /// Generates a unique, order-independent hash for a set of media queries.
    /// - Parameter queries: The media queries to hash.
    /// - Returns: A truncated hash string that uniquely identifies this combination of queries.
    func hashForQueries(_ queries: [any Query]) -> String {
        let sortedQueries = queries.sorted { String(describing: $0) < String(describing: $1) }
        return sortedQueries.map { String(describing: $0) }
            .joined()
            .truncatedHash
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
        properties: [InlineStyle],
        themes: [any Theme]
    ) -> String {
        var rules: [String] = []

        // Only generate base rule if there are no queries
        if queries.isEmpty {
            let baseRule = generateBaseRule(className: className, properties: properties)
            rules.append(baseRule)
        } else {
            // Generate media query rules for each theme
            for theme in themes {
                let themedRule = generateThemedRule(
                    for: queries,
                    className: className,
                    properties: properties,
                    theme: theme
                )
                rules.append(themedRule)
            }
        }

        return rules.joined(separator: "\n\n")
    }

    /// Generates a base CSS rule without theme context
    /// - Parameters:
    ///   - className: The CSS class name to use
    ///   - properties: The CSS properties to apply
    /// - Returns: A CSS rule string
    private func generateBaseRule(className: String, properties: [InlineStyle]) -> String {
        let styleRules = properties.map { "\($0.property): \($0.value);" }.joined(separator: " ")
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
    ///   - properties: The CSS properties to apply
    ///   - theme: The theme context for this rule
    /// - Returns: A CSS rule string with theme context
    private func generateThemedRule(
        for queries: [any Query],
        className: String,
        properties: [InlineStyle],
        theme: any Theme
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

        let selector = "[data-bs-theme=\"\(theme.cssID)\"]"
        let styleRules = properties.map { "\($0.property): \($0.value);" }.joined(separator: " ")

        if mediaQueries.isEmpty {
            return """
            @media (prefers-color-scheme: \(theme.name)) {
                \(selector) .\(className) {
                    \(styleRules)
                }
            }
            """
        } else {
            return """
            @media (\(mediaQueries.joined(separator: ") and ("))) {
                \(selector) .\(className) {
                    \(styleRules)
                }
            }
            """
        }
    }
}
