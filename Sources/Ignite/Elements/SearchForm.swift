//
// SearchForm.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An action that triggers the search functionality.
struct SearchAction: Action {
    func compile() -> String {
        "performSearch(document.querySelector('[id^=\'search-input-\']').value)"
    }
}

/// A form that performs site-wide search.
public struct SearchForm: HTML, NavigationItem {
    /// The appearance of the search-button label.
    public enum SearchButtonStyle: Sendable, Equatable, CaseIterable {
        case iconOnly, titleAndIcon, titleOnly
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The view displayed for each search result.
    private var resultView: any HTML

    /// The view displayed when there are no results.
    private var noResultsView: any HTML

    /// A view displayed at the top of the search results page.
    private var resultsPageHeader: any HTML

    /// This text provides a hint to users about what they can search for.
    private var prompt: String = "Search"

    /// How a `NavigationBar` displays this item at different breakpoints.
    public var navigationBarVisibility: NavigationBarVisibility = .automatic

    /// Whether this dropdown needs to be created as its own element,
    /// or whether it uses the structure provided by a parent `NavigationBar`.
    var isNavigationItem = false

    /// The text displayed on the search button.
    private var searchButtonLabel = "Search"

    /// The appearance of the search-button label.
    private var searchButtonStyle: SearchButtonStyle = .iconOnly

    /// The visual style of the search button.
    private var searchButtonRole: Role = .primary

    /// The size of the form controls
    private var controlSize: ControlSize = .medium

    /// The text color for the search button.
    private var searchButtonForegroundStyle: Color?

    /// Whether the search results HTML `<template>` block should be included.
    private var isSearchResultsTemplateHidden = false

    /// The identifier associated with this form.
    private let searchID = UUID().uuidString.truncatedHash

    /// Creates a new search field with customizable result view.
    /// - Parameters:
    ///   - resultView: A closure that returns a custom view for displaying search result data.
    ///   - resultsPageHeader: A closure that returns a custom view to display
    ///   at the top of the search results page.
    public init(
        @HTMLBuilder resultView: (_ result: SearchResult) -> some HTML,
        @HTMLBuilder noResultsView: () -> some HTML = { EmptyHTML() },
        @HTMLBuilder resultsPageHeader: () -> some HTML = { EmptyHTML() }
    ) {
        self.resultView = resultView(SearchResult())
        self.noResultsView = noResultsView()
        self.resultsPageHeader = resultsPageHeader()
        publishingContext.isSearchEnabled = true
    }

    /// Sets the text displayed on the search button.
    /// - Parameter label: The text to display on the button.
    /// - Returns: A modified form with the updated button text.
    public func searchButtonLabel(_ label: String) -> Self {
        var copy = self
        copy.searchButtonLabel = label
        return copy
    }

    /// Sets the icon and label visibility of the search button.
    /// - Parameter style: The style to apply to the button.
    /// - Returns: A modified form with the updated button style.
    public func searchButtonStyle(_ style: SearchButtonStyle) -> Self {
        var copy = self
        copy.searchButtonStyle = style
        return copy
    }

    /// Sets the size of form controls and labels
    /// - Parameter size: The desired size
    /// - Returns: A modified form with the specified control size
    public func controlSize(_ size: ControlSize) -> Self {
        var copy = self
        copy.controlSize = size
        return copy
    }

    /// Sets the visual role of the search button.
    /// - Parameter role: The role determining the button's appearance.
    /// - Returns: A modified form with the specified button role.
    public func searchButtonRole(_ role: Role) -> Self {
        var copy = self
        copy.searchButtonRole = role
        return copy
    }

    /// Sets the text color of the search button.
    /// - Parameter style: The color to apply to the button text.
    /// - Returns: A modified form with the specified button text color.
    public func searchButtonForegroundStyle(_ style: Color) -> Self {
        var copy = self
        copy.searchButtonForegroundStyle = style
        return copy
    }

    /// Sets the placeholder text for the search input field.
    /// - Parameter prompt: The text to display when the input is empty.
    /// - Returns: A modified search form with the new placeholder text.
    public func searchPrompt(_ prompt: String) -> Self {
        var copy = self
        copy.prompt = prompt
        return copy
    }

    /// Hides the search results `<template>` block from the rendered HTML.
    /// - Returns: A modified form with the specified template visibility.
    private func searchResultsTemplateHidden() -> Self {
        var copy = self
        copy.isSearchResultsTemplateHidden = true
        return copy
    }

    private func renderForm() -> Markup {
        Form(spacing: .none) {
            Section {
                TextField("Search", prompt: prompt)
                    .id("search-input-\(searchID)")
                    .labelStyle(.hidden)
                    .size(controlSize)
                    .customAttribute(name: "inputmode", value: "search")
                    .style(.paddingRight, "35px")

                Button(Span("").class("bi bi-x-circle-fill"))
                    .style(.position, "absolute")
                    .style(.zIndex, "100")
                    .style(.right, "0px")
                    .style(.top, "0px")
                    .style(.display, "none")
            }
            .style(.flex, "1")
            .class(isNavigationItem ? nil : "me-2")
            .style(.position, "relative")

            if !isNavigationItem {
                Button(
                    searchButtonStyle != .iconOnly ? searchButtonLabel : "",
                    systemImage: searchButtonStyle != .titleOnly ? "search" : nil
                ) {
                    SearchAction()
                }
                .type(.submit)
                .role(searchButtonRole)
                .style(.color, searchButtonForegroundStyle != nil ?
                       searchButtonForegroundStyle!.description : "")
            }
        }
        .configuredAsNavigationItem(isNavigationItem)
        .controlSize(controlSize)
        .labelStyle(.hidden)
        .class("align-items-center")
        .customAttribute(name: "role", value: "search")
        .customAttribute(name: "onsubmit", value: "return false")
        .id("search-form-\(searchID)")
        .style(.minWidth, "125px")
        .attributes(attributes)
        .markup()
    }

    private func renderTemplate() -> Markup {
        Tag("template") {
            if resultsPageHeader.isEmpty == false {
                AnyHTML(resultsPageHeader)
                    .class("search-results-header")
            }

            SearchForm { _ in EmptyHTML() }
                .searchResultsTemplateHidden()
                .class("results-search-form")
                .margin(.bottom)

            Section(resultView)
                .class("search-results-item")
                .margin(.bottom, .medium)

            if noResultsView.isEmpty == false {
                AnyHTML(noResultsView)
                    .class("no-results-view")
            }
        }
        .id("search-results-\(searchID)")
        .markup()
    }

    public func markup() -> Markup {
        var output = renderForm()
        if !isSearchResultsTemplateHidden {
            output += renderTemplate()
        }
        return output
    }
}

extension SearchForm: NavigationItemConfigurable {}
