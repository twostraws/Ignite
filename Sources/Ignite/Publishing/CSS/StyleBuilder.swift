//
// StyleBuilder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A result builder for creating arrays of InlineStyle
@resultBuilder
struct StyleBuilder {
    static func buildBlock(_ components: InlineStyle...) -> [InlineStyle] {
        components
    }

    static func buildBlock(_ components: InlineStyle) -> [InlineStyle] {
        [components]
    }

    static func buildBlock(_ components: [InlineStyle]) -> [InlineStyle] {
        components
    }

    // Handle optional styles
    static func buildExpression(_ expression: InlineStyle?) -> [InlineStyle] {
        expression.map { [$0] } ?? []
    }

    // Handle arrays of optional styles
    static func buildExpression(_ expression: [InlineStyle?]) -> [InlineStyle] {
        expression.compactMap { $0 }
    }

    // Combine multiple components
    static func buildBlock(_ components: [InlineStyle]...) -> [InlineStyle] {
        components.flatMap { $0 }
    }

    // Handle optional blocks
    static func buildOptional(_ component: [InlineStyle]?) -> [InlineStyle] {
        component ?? []
    }

    // Handle conditional blocks
    static func buildEither(first component: [InlineStyle]) -> [InlineStyle] {
        component
    }

    static func buildEither(second component: [InlineStyle]) -> [InlineStyle] {
        component
    }

    // Handle arrays of blocks
    static func buildArray(_ components: [[InlineStyle]]) -> [InlineStyle] {
        components.flatMap { $0 }
    }
}
