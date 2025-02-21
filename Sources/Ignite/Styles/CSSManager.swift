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

    /// Queue of registrations waiting to be processed
    private struct PendingRegistration {
        let queries: [any Query]
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

    /// Processes all registrations
    /// - Parameter themes: Array of themes from the site.
    /// - Returns: A string containing all generated CSS rules, separated by newlines.
    func generateAllRules(themes: [Theme]) -> String {
        rules.removeAll()
        classNames.removeAll()
        styleProperties.removeAll()

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
        _ queries: [any Query],
        properties: [(String, String)] = [("display", "none")],
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
        properties: [(String, String)],
        themes: [Theme]
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
        for queries: [any Query],
        className: String,
        properties: [(String, String)],
        theme: Theme
    ) -> String {
        let (_, mediaQueries) = queries.reduce(into: (Set<String>(), [String]())) { result, query in
            if let themeQuery = query as? ThemeQuery {
                result.0.insert(themeQuery.id.kebabCased())
            } else {
                result.1.append(query.condition(with: theme))
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
}
