//
// SyntaxHighlightGenerator.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

@MainActor
struct SyntaxHighlightGenerator {
    var site: any Site

    func generateSyntaxHighlighters(context: PublishingContext) -> String {
        var result = ""

        var highlighters = context.syntaxHighlighters.union(
            context.site.syntaxHighlighterConfiguration.languages
        )
        var highlightersCount = 0

        // A lazy way to recursively scan through dependencies
        repeat {
            highlightersCount = highlighters.count
            let dependencies = highlighters.compactMap(\.dependency)

            for dependency in dependencies where highlighters.contains(dependency) == false {
                highlighters.append(dependency)
            }
        } while highlightersCount != highlighters.count

        var filenames = highlighters.map { "Resources/js/prism-\($0.rawValue.lowercased())" }
        filenames.append("Resources/js/prism-core")

        // Add our highlighters in reverse order, so dependencies are added first
        for filename in filenames.reversed() {
            guard let url = Bundle.module.url(forResource: filename, withExtension: "js") else {
                context.addError(.missingSyntaxHighlighter(filename))
                continue
            }

            guard let contents = try? String(contentsOf: url) else {
                context.addError(.failedToLoadSyntaxHighlighter(filename))
                continue
            }

            result += contents
        }

        return result
    }
}
