//
// ResolvedStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A concrete implementation of a style that contains all necessary information to generate CSS.
///
/// This type serves as the final form of all styles in Ignite, containing the exact CSS property,
/// value, and any media queries or selectors that should be applied. All other style types must
/// eventually resolve to this type through their `body` property.
struct ResolvedStyle: Style {
    /// The unique class name for this style
    public let className: String

    /// The CSS property-value pairs for this style
    let declarations: [AttributeValue]

    /// Any media queries that should wrap this style
    let mediaQueries: [MediaQuery]

    /// Any selectors that should be applied to this style
    let selectors: [Selector]

    /// Returns self since this is already a resolved style
    public var body: some Style { self }

    /// Creates a new resolved style with the specified properties
    init(
        declarations: [AttributeValue] = [],
        mediaQueries: [MediaQuery] = [],
        selectors: [Selector] = [],
        className: String? = nil
    ) {
        self.className = className ?? "style-\(Self.id)"
        self.mediaQueries = mediaQueries
        self.declarations = declarations
        self.selectors = selectors
    }

    /// Generates the complete CSS rule string for this style
    var cssRule: String {
        var rules: [String] = []

        // Base rule (no media query, no selector)
        if !declarations.isEmpty && selectors.isEmpty && mediaQueries.isEmpty {
            let properties = declarations
                .filter { !$0.value.isEmpty }
                .map { "\($0.name): \($0.value);" }
                .joined(separator: "\n    ")

            if !properties.isEmpty {
                rules.append("""
                .\(className) {
                    \(properties)
                }
                """)
            }
        }

        // Rules with selectors but no media queries
        if !declarations.isEmpty && !selectors.isEmpty && mediaQueries.isEmpty {
            for selector in selectors {
                let properties = declarations
                    .filter { !$0.value.isEmpty }
                    .map { "\($0.name): \($0.value);" }
                    .joined(separator: "\n    ")

                if !properties.isEmpty {
                    rules.append("""
                    \(selector.conditions.joined(separator: " ")) .\(className) {
                        \(properties)
                    }
                    """)
                }
            }
        }

        // Rules with media queries
        for mediaQuery in mediaQueries {
            // Media query with no selector
            if selectors.isEmpty {
                let properties = declarations
                    .filter { !$0.value.isEmpty }
                    .map { "\($0.name): \($0.value);" }
                    .joined(separator: "\n        ")

                if !properties.isEmpty {
                    rules.append("""
                    @media \(mediaQuery.conditions.joined(separator: " and ")) {
                        .\(className) {
                            \(properties)
                        }
                    }
                    """)
                }
            }

            // Media query with selectors
            for selector in selectors {
                let properties = declarations
                    .filter { !$0.value.isEmpty }
                    .map { "\($0.name): \($0.value);" }
                    .joined(separator: "\n        ")

                if !properties.isEmpty {
                    rules.append("""
                    @media \(mediaQuery.conditions.joined(separator: " and ")) {
                        \(selector.conditions.joined(separator: " ")) .\(className) {
                            \(properties)
                        }
                    }
                    """)
                }
            }
        }

        return rules.joined(separator: "\n\n")
    }
}
