//
// StyleBuilder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A result builder that composes multiple styles into a single resolved style.
///
/// StyleBuilder combines properties from multiple style components, including media queries,
/// selectors, and CSS properties, resolving them into a concrete `ResolvedStyle`.
@resultBuilder
public struct StyleBuilder {
    /// Combines multiple style components into a single resolved style.
    ///
    /// This method merges properties from all provided components, with later components
    /// taking precedence over earlier ones for conflicting values.
    public static func buildBlock(_ components: any Style...) -> some Style {
        var mediaQueries: [MediaQuery] = []
        var baseValue = ""
        var selectors: [Selector] = []
        var property = Property.color.rawValue
        var targetClass: String? = nil

        let className = components.first?.className ?? "unknown-\(UUID().uuidString.truncatedHash)"

        for component in components {
            let resolved = (component as? ResolvedStyle) ?? ResolvedStyle()

            if !resolved.value.isEmpty {
                baseValue = resolved.value
                property = resolved.property
            }

            selectors.append(contentsOf: resolved.selectors)
            mediaQueries.append(contentsOf: resolved.mediaQueries)
        }

        return ResolvedStyle(
            property: property,
            value: baseValue,
            mediaQueries: mediaQueries,
            selectors: selectors,
            className: className
        )
    }

    /// Handles optional style components by providing a default empty style.
    public static func buildOptional(_ component: (any Style)?) -> any Style {
        component ?? ResolvedStyle()
    }

    /// Handles conditional style components by forwarding the first component.
    public static func buildEither(first component: any Style) -> any Style {
        component
    }

    /// Handles conditional style components by forwarding the second component.
    public static func buildEither(second component: any Style) -> any Style {
        component
    }
}
