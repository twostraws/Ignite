//
// SearchResult.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
public struct SearchResult: Sendable {
    public var title: some HTML = Text("").class("result-title")
    public var link: some HTML = Link("", target: "").class("result-link")
    public var description: some HTML = Text("").class("result-description")
    public var tags: some HTML = Text("").class("result-tags")
}
