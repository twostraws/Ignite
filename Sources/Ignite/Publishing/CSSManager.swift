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
    static let `default` = CSSManager()

    /// All themes available in the site
    private var themes: [Theme] = []

    /// Queue of registrations waiting for themes to be set
    private struct PendingRegistration {
        let queries: [MediaQuery]
        let properties: [(String, String)]
        let className: String?
    }

    /// Returns true if custom CSS has been registered.
    var hasCSS: Bool { !pendingRegistrations.isEmpty }

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
            register(
                registration.queries,
                properties: registration.properties,
                className: registration.className
            )
        }
        pendingRegistrations.removeAll()
    }

    /// Registers a set of media queries and generates a corresponding CSS class
    /// - Parameters:
    ///   - queries: Media queries that determine when styles should be applied
    ///   - properties: CSS property names and values to apply
    ///   - className: Optional specific class name to use (generates one if nil)
    /// - Returns: The class name used for these styles
    @discardableResult
    func register(
        _ queries: [MediaQuery],
        properties: [(String, String)] = [("display", "none")],
        className: String? = nil
    ) -> String {
        let hash = hashForQueries(queries)

        if themes.isEmpty {
            // Queue the registration for later
            pendingRegistrations.append(PendingRegistration(
                queries: queries,
                properties: properties,
                className: className
            ))
            // Return the class name that will be used
            return className ?? "style-\(hash)"
        }

        let finalClassName = className ?? "style-\(hash)"
        classNames[hash] = finalClassName
        styleProperties[hash] = properties
        rules[hash] = generateCSSRule(for: queries, className: finalClassName, properties: properties)

        return finalClassName
    }

    /// Gets the class name for a set of media queries.
    /// - Parameter queries: The media queries to look up.
    /// - Returns: The corresponding CSS class name, or an empty string if not found.
    func className(for queries: [MediaQuery]) -> String {
        let hash = hashForQueries(queries)
        return classNames[hash] ?? ""
    }

    /// Generates a unique, order-independent hash for a set of media queries.
    /// - Parameter queries: The media queries to hash.
    /// - Returns: A truncated hash string that uniquely identifies this combination of queries.
    func hashForQueries(_ queries: [MediaQuery]) -> String {
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
    /// - Returns: A CSS rule string.
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
        let (_, mediaQueries) = queries.reduce(into: (Set<String>(), [String]())) { result, query in
            if case .theme(let id) = query {
                result.0.insert(id.kebabCased())
            } else {
                result.1.append(query.query(with: theme))
            }
        }

        let selector = "[data-theme-state=\"\(theme.id)\"]"
        let styleRules = properties.map { "\($0.0): \($0.1);" }.joined(separator: " ")

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

    /// A string containing all generated CSS rules, separated by newlines.
    var allRules: String {
        rules.values.joined(separator: "\n\n")
    }
}
