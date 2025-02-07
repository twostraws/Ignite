//
// Content.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
public struct ContentLoader {
    public var all: [MarkdownContent]

    init(content: [MarkdownContent]) {
        all = content
    }

    public func typed(_ type: String) -> [MarkdownContent] {
        all.filter { $0.type == type }
    }

    public func tagged(_ tag: String) -> [MarkdownContent] {
        all.filter { $0.tags.contains(tag) }
    }
}
