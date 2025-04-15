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

    /// Controls whether this dropdown needs to be created as its own element,
    /// or whether it uses the structure provided by a parent `NavigationBar`.
    private var isNavigationItem = false

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

    /// Configures this dropdown to be placed inside a `NavigationBar`.
    /// - Returns: A new `Form` instance suitable for placement
    /// inside a `NavigationBar`.
    func configuredAsNavigationItem() -> Self {
        var copy = self
        copy.isNavigationItem = true
        return copy
    }

    public func render() -> String {
        Section {
            Form(spacing: .none) {
                Section {
                    TextField(label, prompt: prompt)
                        .id("search-input-\(UUID().uuidString.truncatedHash)")
                        .labelStyle(.hidden)
                        .style(.paddingRight, "35px")

                    Button(Span("").class("bi bi-x-circle-fill"))
                        .id("search-clear")
                        .style(.position, "absolute")
                        .style(.zIndex, "100")
                        .style(.right, "0px")
                        .style(.top, "0px")
                }
                .style(.width, "fit-content")
                .style(.minWidth, "175px")
                .style(.flex, "1")
                .class(isNavigationItem ? nil : "col-auto")
                .class("me-2")
                .style(.position, "relative")

                Button("Search") {
                    SearchAction()
                }
                .type(.submit)
                .role(.primary)
            }
            .configuredAsNavigationItem(isNavigationItem)
            .labelStyle(.hidden)
            .id("search-form")
            .class("align-items-center")
            .customAttribute(name: "onsubmit", value: "return false")

            Tag("template") {
                Section(searchResultView)
                    .class("search-results-item")
                    .margin(.bottom, .medium)
            }
            .id("search-results")
        }
        .render()
    }
}
