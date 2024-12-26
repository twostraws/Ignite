//
// CSSManager.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A manager that generates and maintains CSS classes for media query-based styling rules.
final class CSSManager {
    /// The shared instance used for managing CSS rules across the application.
    @MainActor static let `default` = CSSManager()

    /// All themes available in the site
    private var themes: [Theme] = []

    /// Queue of registrations waiting for themes to be set
    private struct PendingRegistration {
        let queries: [MediaQuery]
        let properties: [(String, String)]
        let className: String?
    }
    private var pendingRegistrations: [PendingRegistration] = []

    /// A mapping of query hashes to their corresponding CSS class names.
    private var classNames: [String: String] = [:]

    /// A mapping of query hashes to their generated CSS rules.
    private var rules: [String: String] = [:]

    /// A mapping of query hashes to their style properties.
    private var styleProperties: [String: [(String, String)]] = [:]

    /// Sets the themes and processes any pending registrations
    /// - Parameter themes: Array of themes from the site
    func setThemes(_ themes: [Theme]) {
        self.themes = themes

        // Process all pending registrations
        for registration in pendingRegistrations {
            if let className = registration.className {
                register(registration.queries, properties: registration.properties, className: className)
            } else {
                register(registration.queries, properties: registration.properties)
            }
        }
        pendingRegistrations.removeAll()
    }

    /// Registers a set of media queries and generates a corresponding CSS class if needed.
    /// - Parameters:
    ///   - queries: An array of media queries that determine when styles should be applied.
    ///   - properties: An array of tuples containing CSS property names and values.
    func register(_ queries: [MediaQuery], properties: [(String, String)] = [("display", "none")]) {
        if themes.isEmpty {
            // Queue the registration for later
            pendingRegistrations.append(PendingRegistration(queries: queries, properties: properties, className: nil))
            return
        }

        let hash = hashForQueries(queries)
        if classNames[hash] == nil {
            let className = "style-\(hash)"
            classNames[hash] = className
            styleProperties[hash] = properties
            rules[hash] = generateCSSRule(for: queries, className: className, properties: properties)
        }
    }

    /// Registers a set of media queries with a specific class name
    /// - Parameters:
    ///   - queries: An array of media queries that determine when styles should be applied.
    ///   - properties: An array of tuples containing CSS property names and values.
    ///   - className: The specific class name to use for these styles.
    func register(_ queries: [MediaQuery], properties: [(String, String)], className: String) {
        if themes.isEmpty {
            // Queue the registration for later
            pendingRegistrations.append(PendingRegistration(queries: queries, properties: properties, className: className))
            return
        }

        let hash = hashForQueries(queries)
        classNames[hash] = className
        styleProperties[hash] = properties
        rules[hash] = generateCSSRule(for: queries, className: className, properties: properties)
    }

    /// Returns the CSS class name for a specific combination of media queries.
    /// - Parameter queries: The media queries to look up.
    /// - Returns: The corresponding CSS class name, or an empty string if not found.
    func className(for queries: [MediaQuery]) -> String {
        let hash = hashForQueries(queries)
        return classNames[hash] ?? ""
    }

    /// Generates a unique, order-independent hash for a set of media queries.
    /// - Parameter queries: The media queries to hash.
    /// - Returns: A truncated hash string that uniquely identifies this combination of queries.
    private func hashForQueries(_ queries: [MediaQuery]) -> String {
        let sortedQueries = queries.sorted { String(describing: $0) < String(describing: $1) }
        return sortedQueries.map { String(describing: $0) }
            .joined()
            .truncatedHash
    }

    /// Generates a CSS rule for applying styles based on the provided queries.
    /// - Parameters:
    ///   - queries: The media queries that determine when the rule applies.
    ///   - className: The CSS class name to use in the generated rule.
    ///   - properties: An array of tuples containing CSS property names and values.
    /// - Returns: A CSS rule string that implements the styling behavior.
    private func generateCSSRule(
        for queries: [MediaQuery],
        className: String,
        properties: [(String, String)]
    ) -> String {
        var rules: [String] = []

        // Only generate base rule if there are no queries
        if queries.isEmpty {
            let baseRule = generateBaseRule(className: className, properties: properties)
            rules.append(baseRule)

            // Generate themed base rules
            for theme in themes {
                let themedBaseRule = """
                [data-bs-theme="\(theme.id)"] .\(className) {
                    \(properties.map { "\($0.0): \($0.1);" }.joined(separator: " "))
                }
                """
                rules.append(themedBaseRule)
            }
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
    private func generateBaseRule(className: String, properties: [(String, String)]) -> String {
        let styleRules = properties.map { "\($0.0): \($0.1);" }.joined(separator: " ")
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
        for queries: [MediaQuery],
        className: String,
        properties: [(String, String)],
        theme: Theme
    ) -> String {
        let (themeQueries, mediaQueries) = queries.reduce(into: (Set<String>(), [String]())) { result, query in
            if case .theme(let id) = query {
                result.0.insert(id.kebabCased())
            } else {
                result.1.append(query.query(with: theme))
            }
        }

        let selector = "[data-bs-theme=\"\(theme.id)\"]"
        let styleRules = properties.map { "\($0.0): \($0.1);" }.joined(separator: " ")

        if !mediaQueries.isEmpty {
            let mediaConditions = mediaQueries.joined(separator: ") and (")
            return """
            @media (\(mediaConditions)) {
                \(selector) .\(className) {
                    \(styleRules)
                }
            }
            """
        } else {
            return """
            \(selector) .\(className) {
                \(styleRules)
            }
            """
        }
    }

    /// A string containing all generated CSS rules, separated by newlines.
    var allRules: String {
        rules.values.joined(separator: "\n\n")
    }
}
