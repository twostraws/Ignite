//
// Markup-IsInsideList.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Markdown

extension Markdown.Markup {
    /// Only paragraphs directly inside a tight list item omit their paragraph container.
    func isInTightList(sourceLines: [Substring]) -> Bool {
        guard let item = parent as? Markdown.ListItem, let list = item.parent as? any ListItemContainer else {
            return false
        }

        return list.isTight(sourceLines: sourceLines)
    }
}

extension Markdown.ListItemContainer {
    /// A list is tight when its items and direct child blocks have no blank-line boundaries.
    func isTight(sourceLines: [Substring]) -> Bool {
        var quoteDepth = 0
        var ancestor = parent
        while let current = ancestor {
            if current is BlockQuote { quoteDepth += 1 }
            ancestor = current.parent
        }

        func isBlankLine(_ line: Int) -> Bool {
            guard sourceLines.indices.contains(line - 1) else { return false }
            var text = sourceLines[line - 1]
            for _ in 0..<quoteDepth {
                text = text.drop { $0 == " " || $0 == "\t" }
                if text.first == ">" { text = text.dropFirst() }
            }
            return text.allSatisfy { $0 == " " || $0 == "\t" }
        }

        func lastContentLine(_ markup: any Markdown.Markup) -> Int? {
            // List ranges can include trailing blank lines. Nested lists and items
            // inherit their last child's end, but code and quotes remain independent blocks.
            if markup is Markdown.ListItem || markup is any ListItemContainer, markup.childCount > 0,
               let last = markup.child(at: markup.childCount - 1) {
                return lastContentLine(last)
            }
            guard let range = markup.range else { return nil }
            var line = range.upperBound.line
            while line > range.lowerBound.line, isBlankLine(line) { line -= 1 }
            return line
        }

        func hasBlankLine(between previous: any Markdown.Markup, and next: any Markdown.Markup) -> Bool {
            guard let end = lastContentLine(previous), let start = next.range?.lowerBound.line,
                  start > end + 1 else { return false }
            return ((end + 1)..<start).contains(where: isBlankLine)
        }

        var previousItem: Markdown.ListItem?
        for listItem in listItems {
            if let previousItem, hasBlankLine(between: previousItem, and: listItem) { return false }
            var previousBlock: (any Markdown.Markup)?
            for block in listItem.children {
                if let previousBlock, hasBlankLine(between: previousBlock, and: block) { return false }
                previousBlock = block
            }
            previousItem = listItem
        }
        return true
    }
}
