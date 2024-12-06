//
// ResolvedStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A concrete implementation of `Style` that generates CSS rules from its properties.
///
/// `ResolvedStyle` combines media queries, selectors, and CSS properties to generate
/// complete CSS rules. It's typically created by the style system rather than directly.
struct ResolvedStyle: Style {
    /// Optional prefix for the class name, defaults to nil
    public static var prefix: String? { nil }

    /// The CSS class name for this style
    let className: String

    /// The CSS property to set (e.g., "color", "font-size")
    let property: String

    /// The value to apply to the CSS property
    let value: String

    /// Media queries to apply to this style
    let mediaQueries: [MediaQuery]

    /// Selectors that determine when this style applies (e.g., :hover, :active)
    let selectors: [Selector]

    /// Returns self since `ResolvedStyle` is a leaf node in the style hierarchy
    public var body: some Style { self }

    /// Creates a new resolved style with the specified properties
    init(
        property: String = "color",
        value: String = "",
        mediaQueries: [MediaQuery] = [],
        selectors: [Selector] = [],
        className: String? = nil
    ) {
        self.className = className ?? "style-\(Self.id)"
        self.mediaQueries = mediaQueries
        self.value = value
        self.property = property
        self.selectors = selectors
    }

    /// Generates the complete CSS rule string for this style
    var cssRule: String {
        var rules: [String] = []

        // Base rule (no media query, no selector)
        if !value.isEmpty && selectors.isEmpty && mediaQueries.isEmpty {
            rules.append("""
            .\(className) {
                \(property): \(value);
            }
            """)
        }

        // Selector-only rules (no media query)
        if !selectors.isEmpty && mediaQueries.isEmpty {
            for selector in selectors {
                let conditions = selector.conditions.joined(separator: " ")
                rules.append("""
                \(conditions) .\(className) {
                    \(property): \(value);
                }
                """)
            }
        }

        // Media query rules (with or without selectors)
        for query in mediaQueries {
            let mediaConditions = query.conditions.joined(separator: " and ")

            if selectors.isEmpty {
                rules.append("""
                @media \(mediaConditions) {
                    .\(className) {
                        \(property): \(value);
                    }
                }
                """)
            } else {
                for selector in selectors {
                    let selectorConditions = selector.conditions.joined(separator: " ")
                    rules.append("""
                    @media \(mediaConditions) {
                        \(selectorConditions) .\(className) {
                            \(property): \(value);
                        }
                    }
                    """)
                }
            }
        }

        return rules.joined(separator: "\n\n")
    }
}
