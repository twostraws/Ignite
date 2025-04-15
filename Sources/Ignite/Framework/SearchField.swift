//
// SearchField.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct SearchAction: Action {
    func compile() -> String {
        "performSearch(document.getElementById('search-input').value)"
    }
}

public struct SearchField: HTML, NavigationItem {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    private var searchResultView: any HTML

    private var prompt: String?

    private var label: any InlineElement

    public init(
        _ label: any InlineElement,
        prompt: String? = nil,
        @HTMLBuilder searchResultView: (SearchResult) -> some HTML
    ) {
        self.searchResultView = searchResultView(SearchResult())
        self.prompt = prompt
        self.label = label
    }

    public func render() -> String {
        publishingContext.isSearchEnabled = true
        return Section {
            Form {
                TextField(label, prompt: prompt)
                    .id("search-input")
                Button("Search") {
                    SearchAction()
                }
                .type(.submit)
                .role(.primary)
            }
            .labelStyle(.hidden)
            .id("search-form")
            .customAttribute(name: "onsubmit", value: "return false")

            Section(searchResultView)
                .id("search-results")
                .class("search-results")
        }
        .render()
    }
}
