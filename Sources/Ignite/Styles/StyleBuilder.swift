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
    public static func buildBlock<Content: Style>(_ component: Content) -> some Style {
        component
    }

    /// Combines the first style component in a sequence.
    public static func buildPartialBlock<Content: Style>(first: Content) -> some Style {
        first
    }

    /// Combines an accumulated style with the next style in sequence.
    public static func buildPartialBlock(accumulated: any Style, next: any Style) -> some Style {
        let accumulatedResolved = (accumulated as? ResolvedStyle) ??
        (accumulated.body as? ResolvedStyle) ??
        ResolvedStyle()

        let nextResolved = (next as? ResolvedStyle) ??
        (next.body as? ResolvedStyle) ??
        ResolvedStyle()

        var combinedStyles = accumulatedResolved.declarations
        combinedStyles.append(contentsOf: nextResolved.declarations)

        return ResolvedStyle(
            declarations: combinedStyles,
            mediaQueries: accumulatedResolved.mediaQueries + nextResolved.mediaQueries,
            selectors: accumulatedResolved.selectors + nextResolved.selectors,
            className: accumulatedResolved.className
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
