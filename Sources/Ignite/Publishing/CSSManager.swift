//
// CSSManager.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A manager that generates and maintains CSS classes for media query-based visibility rules.
final class CSSManager {
    /// The shared instance used for managing CSS rules across the application.
    @MainActor static let `default` = CSSManager()

    /// A mapping of query hashes to their corresponding CSS class names.
    private var classNames: [String: String] = [:]

    /// A mapping of query hashes to their generated CSS rules.
    private var rules: [String: String] = [:]

    /// Registers a set of media queries and generates a corresponding CSS class if needed.
    /// - Parameter queries: An array of media queries that determine when an element should be hidden.
    func register(_ queries: [MediaQuery]) {
        let hash = hashForQueries(queries)

        if classNames[hash] == nil {
            let className = "hide-\(hash)"
            classNames[hash] = className
            rules[hash] = generateCSSRule(for: queries, className: className)
        }
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

    /// Generates a CSS rule for hiding elements based on the provided queries.
    /// - Parameters:
    ///   - queries: The media queries that determine when the rule applies.
    ///   - className: The CSS class name to use in the generated rule.
    /// - Returns: A CSS rule string that implements the hiding behavior.
    private func generateCSSRule(for queries: [MediaQuery], className: String) -> String {
        let (themeQueries, mediaQueries) = queries.reduce(into: (Set<String>(), [String]())) { result, query in
            if case .theme(let id) = query {
                result.0.insert(id.kebabCased())
            } else {
                result.1.append(query.query)
            }
        }

        var selector = ""

        if !themeQueries.isEmpty {
            selector += themeQueries.map { "[data-theme-state=\"\($0)\"]" }.joined(separator: ", ")
        }

        if !mediaQueries.isEmpty {
            let mediaConditions = mediaQueries.joined(separator: ") and (")
            if !selector.isEmpty {
                return """
                @media (\(mediaConditions)) {
                    \(selector) .\(className) {
                        display: none;
                    }
                }
                """
            } else {
                return """
                @media (\(mediaConditions)) {
                    .\(className) {
                        display: none;
                    }
                }
                """
            }
        } else if !selector.isEmpty {
            return """
            \(selector) .\(className) {
                display: none;
            }
            """
        }

        return ""
    }

    /// A string containing all generated CSS rules, separated by newlines.
    var allRules: String {
        rules.values.joined(separator: "\n\n")
    }
}
