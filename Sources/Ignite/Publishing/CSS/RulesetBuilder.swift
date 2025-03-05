//
// RulesetBuilder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@resultBuilder
struct RulesetBuilder {
    static func buildBlock(_ components: Ruleset...) -> [Ruleset] {
        components
    }

    static func buildBlock(_ components: Ruleset) -> [Ruleset] {
        [components]
    }

    static func buildBlock(_ components: [Ruleset]) -> [Ruleset] {
        components
    }

    static func buildOptional(_ component: [Ruleset]?) -> [Ruleset] {
        component ?? []
    }

    static func buildEither(first component: [Ruleset]) -> [Ruleset] {
        component
    }

    static func buildEither(second component: [Ruleset]) -> [Ruleset] {
        component
    }

    static func buildArray(_ components: [[Ruleset]]) -> [Ruleset] {
        components.flatMap { $0 }
    }

    // Add support for arrays of Rulesets
    static func buildExpression(_ expression: [Ruleset]) -> [Ruleset] {
        expression
    }

    // Add support for individual Rulesets
    static func buildExpression(_ expression: Ruleset) -> [Ruleset] {
        [expression]
    }
}
