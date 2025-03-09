//
// CSSBuilder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

typealias RulesetBuilder = CSSBuilder<Ruleset>
typealias StyleBuilder = CSSBuilder<InlineStyle>

/// A generic result builder for creating arrays of CSS elements (Ruleset or InlineStyle)
@resultBuilder
struct CSSBuilder<Element> {
    static func buildBlock(_ components: Element...) -> [Element] {
        components
    }

    static func buildBlock(_ components: Element) -> [Element] {
        [components]
    }

    static func buildBlock(_ components: [Element]) -> [Element] {
        components
    }

    static func buildOptional(_ component: [Element]?) -> [Element] {
        component ?? []
    }

    static func buildEither(first component: [Element]) -> [Element] {
        component
    }

    static func buildEither(second component: [Element]) -> [Element] {
        component
    }

    static func buildArray(_ components: [[Element]]) -> [Element] {
        components.flatMap { $0 }
    }

    static func buildExpression(_ expression: [Element]) -> [Element] {
        expression
    }

    static func buildExpression(_ expression: Element) -> [Element] {
        [expression]
    }

    static func buildExpression(_ expression: Element?) -> [Element] {
        expression.map { [$0] } ?? []
    }

    static func buildExpression(_ expression: [Element?]) -> [Element] {
        expression.compactMap { $0 }
    }

    static func buildBlock(_ components: [Element]...) -> [Element] {
        components.flatMap { $0 }
    }
}
