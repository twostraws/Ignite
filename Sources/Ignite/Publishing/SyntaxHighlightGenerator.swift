//
// SyntaxHighlightGenerator.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

struct SyntaxHighlightGenerator {
    var site: any Site

    func generateSyntaxHighlighters() throws -> String {
        var result = ""

        var highlighters = site.syntaxHighlighters
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
                throw PublishingError.missingSyntaxHighlighter(filename)
            }

            guard let contents = try? String(contentsOf: url) else {
                throw PublishingError.failedToLoadSyntaxHighlighter(filename)
            }

            result += contents
        }

        return result
    }
}
