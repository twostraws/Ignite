//
// ImportRule.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Represents a CSS @import rule
struct ImportRule {
    let source: URL

    init(_ source: URL) {
        self.source = source
    }

    func render() -> String {
        "@import url('\(source.absoluteString)');"
    }
}

extension ImportRule: CustomStringConvertible {
    var description: String {
        render()
    }
}
