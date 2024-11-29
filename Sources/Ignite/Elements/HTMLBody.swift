//
// Body.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public struct HTMLBody: RootHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    var items: [any HTML]

    public init(@HTMLBuilder _ items: () -> some HTML) {
        self.items = flatUnwrap(items())
    }

    public init(for page: Page) {
        self.items = flatUnwrap(page.body)
    }

    public func render(context: PublishingContext) -> String {
        var output = ""

        // Render main content
        let rendered = items.map { $0.render(context: context) }.joined()
        output = rendered

        // Add required scripts
        if context.site.useDefaultBootstrapURLs == .localBootstrap {
            output += Script(file: "/js/bootstrap.bundle.min.js").render(context: context)
        }

        if !context.site.syntaxHighlighters.isEmpty {
            output += Script(file: "/js/syntax-highlighting.js").render(context: context)
        }

        if output.contains(#"data-bs-toggle="tooltip""#) {
            output += Script(code: """
            const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
            const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))
            """).render(context: context)
        }

        output += Script(file: "/js/ignite-core.js").render(context: context)

        var attributes = attributes
        attributes.tag = "body"
        return attributes.description(wrapping: output)
    }
}
