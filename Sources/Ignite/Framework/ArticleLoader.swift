//
// Content.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
public struct ArticleLoader {
    public var all: [Article]

    init(content: [Article]) {
        all = content
    }

    public func typed(_ type: String) -> [Article] {
        all.filter { $0.type == type }
    }

    public func tagged(_ tag: String) -> [Article] {
        all.filter { $0.tags?.contains(tag) == true }
    }
}
