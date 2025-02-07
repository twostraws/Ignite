//
// Content.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
public struct ContentLoader {
    public var all: [Content]

    init(content: [Content]) {
        all = content
    }

    public func typed(_ type: String) -> [Content] {
        all.filter { $0.type == type }
    }

    public func tagged(_ tag: String) -> [Content] {
        all.filter { $0.tags.contains(tag) }
    }
}
