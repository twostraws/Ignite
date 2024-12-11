//
// EnvironmentEffect.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies conditional styles based on media queries and theme states.
struct EnvironmentEffectModifier: HTMLModifier {
    /// The media queries to check against.
    private let mediaQueries: [MediaQuery]

    /// The style modifications to apply when conditions are met.
    private let modifications: (any HTML) -> any HTML

    /// Creates a new environment effect modifier.
    /// - Parameters:
    ///   - mediaQueries: The media queries to check against
    ///   - modifications: The style modifications to apply
    init(
        mediaQueries: [MediaQuery],
        modifications: @escaping (any HTML) -> any HTML
    ) {
        self.mediaQueries = mediaQueries
        self.modifications = modifications
    }

    /// Applies the environment-specific modifications to the content.
    /// - Parameter content: The HTML content to modify
    /// - Returns: The modified HTML with conditional styles applied
    func body(content: some HTML) -> any HTML {
        let className = "env-\(content.id)"

        // Apply modifications to a dummy struct with its own ID
        var copy = EmptyHTML()
        let modifiedContent = modifications(copy)
        var modifiedAttributes = modifiedContent.attributes

        let originalAttributes = AttributeStore.default.attributes(for: content.id)
        let newStyles = modifiedAttributes.styles.subtracting(originalAttributes.styles)
        let styleRules = newStyles.map { "\($0.name): \($0.value);" }.joined(separator: " ")

        // Separate theme queries from media queries
        let (themeQueries, mediaQueries) = self.mediaQueries.partition { query in
            if case .theme = query { return true }
            return false
        }

        // Generate CSS rule based on query types
        let cssRule: String
        if !themeQueries.isEmpty && !mediaQueries.isEmpty {
            // Handle combined theme and media queries
            let mediaQueryString = mediaQueries.map { "(\($0.query))" }.joined(separator: " and ")
            let themeSelectors = themeQueries.map { "[\($0.query)]" }.joined(separator: ", ")
            cssRule = """
            @media \(mediaQueryString) {
                \(themeSelectors) .\(className) { \(styleRules) }
            }
            """
        } else if !themeQueries.isEmpty {
            // Handle theme-only queries
            let themeSelectors = themeQueries.map { "[\($0.query)]" }.joined(separator: ", ")
            cssRule = """
            \(themeSelectors) .\(className) { \(styleRules) }
            """
        } else {
            // Handle media-only queries
            let mediaQueryString = mediaQueries.map { "(\($0.query))" }.joined(separator: " and ")
            cssRule = """
            @media \(mediaQueryString) {
                .\(className) { \(styleRules) }
            }
            """
        }

        StyleManager.default.addStyle(cssRule)
        return content.class(className)
    }
}

public extension HTML {
    /// Applies conditional styles based on media queries and theme states.
    /// - Parameters:
    ///   - mediaQueries: One or more media queries to check against
    ///   - modifications: The style modifications to apply when conditions are met
    /// - Returns: A modified copy of the HTML with conditional styles applied
    func environmentEffect(
        _ mediaQueries: MediaQuery...,
        modifications: @escaping (any HTML) -> any HTML
    ) -> some HTML {
        modifier(
            EnvironmentEffectModifier(
                mediaQueries: mediaQueries,
                modifications: modifications
            )
        )
    }
}

// Helper extension for array partition
private extension Array {
    /// Splits an array into two arrays based on a predicate.
    /// - Parameter predicate: A closure that determines which array each element belongs to
    /// - Returns: A tuple containing matching and non-matching elements
    func partition(by predicate: (Element) -> Bool) -> ([Element], [Element]) {
        var matching: [Element] = []
        var nonMatching: [Element] = []

        forEach { element in
            if predicate(element) {
                matching.append(element)
            } else {
                nonMatching.append(element)
            }
        }

        return (matching, nonMatching)
    }
}
