//
// SearchField.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An action that triggers the search functionality.
struct SearchAction: Action {
    func compile() -> String {
        "performSearch(document.getElementById('search-input').value)"
    }
}

/// A search field component that enables site-wide search of articles.
public struct SearchField: HTML, NavigationItem {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The view displayed for each search result.
    private var searchResultView: any HTML

    /// This text provides a hint to users about what they can search for.
    private var prompt: String?

    /// The label text displayed for the search field.
    private var label: any InlineElement

    /// Creates a new search field with customizable result view.
    /// - Parameters:
    ///   - label: The label text displayed for the search field
    ///   - prompt: Optional placeholder text shown when the field is empty
    ///   - searchResultView: A closure that returns a custom HTML view for displaying search results
    public init(
        _ label: any InlineElement,
        prompt: String? = nil,
        @HTMLBuilder searchResultView: (SearchResult) -> some HTML
    ) {
        self.searchResultView = searchResultView(SearchResult())
        self.prompt = prompt
        self.label = label
        publishingContext.isSearchEnabled = true
    }

    public func render() -> String {
        Section {
            Form(spacing: .none) {
                Section {
                    TextField(label, prompt: prompt)
                        .id("search-input")
                        .labelStyle(.hidden)
                        .style(.paddingRight, "35px")
                        .style(.maxWidth, "150px")

                    Button(Span("").class("bi bi-x-circle-fill"))
                        .id("search-clear")
                        .style(.position, "absolute")
                        .style(.zIndex, "100")
                        .style(.right, "0px")
                        .style(.top, "0px")
                }
                .class("col-auto", "me-2")
                .style(.position, "relative")

                Button("Search") {
                    SearchAction()
                }
                .type(.submit)
                .role(.primary)
            }
            .labelStyle(.hidden)
            .id("search-form")
            .class("align-items-center")
            .customAttribute(name: "onsubmit", value: "return false")

            Section(searchResultView.style(.display, "none"))
                .id("search-results")
                .class("search-results")
        }
        .render()
    }
}
