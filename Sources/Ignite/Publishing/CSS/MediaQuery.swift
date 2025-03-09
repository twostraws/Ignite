//
// MediaQuery.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Represents a CSS media query with nested declarations
struct MediaQuery: CustomStringConvertible {
    enum Combinator: String {
        case and = ") and ("
        case or = ") or (" // swiftlint:disable:this identifier_name
    }

    /// The media features to check
    var features: [MediaFeature]

    /// How the features should be combined
    var combinator: Combinator

    /// The nested rulesets within this media query
    var rulesets: [Ruleset]

    init(
        _ features: MediaFeature...,
        combinator: Combinator = .and,
        @RulesetBuilder rulesets: () -> [Ruleset]
    ) {
        self.features = features
        self.combinator = combinator
        self.rulesets = rulesets()
    }

    init(
        _ features: [MediaFeature],
        combinator: Combinator = .and,
        @RulesetBuilder rulesets: () -> [Ruleset]
    ) {
        self.features = features
        self.combinator = combinator
        self.rulesets = rulesets()
    }

    func render() -> String {
        let query = features.map(\.description).joined(separator: combinator.rawValue)
        let rulesBlock = rulesets.map(\.description).joined(separator: "\n\n")

        return """
        @media (\(query)) {
            \(rulesBlock)
        }
        """
    }

    public var description: String {
        render()
    }
}
