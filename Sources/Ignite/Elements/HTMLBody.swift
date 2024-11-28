//
// Body.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public struct HTMLBody: HTMLRootElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { EmptyHTML() }

    var items: any HTML

    public init(@HTMLBuilder _ items: () -> some HTML) {
        self.items = items()
    }

    public init(for page: Page) {
        self.items = page.body
    }

    public func render(context: PublishingContext) -> String {
        var output = ""

        // Render main content
        let rendered = items.render(context: context)
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

        if AnimationManager.default.hasAnimations {
            output += Script(file: "/js/animations.js").render(context: context)
        }
        output += Script(file: "/js/email-protection.js").render(context: context)
        output += Script(file: "/js/theme-switcher.js").render(context: context)

        return "<body\(attributes.description())>\(output)</body>"
    }
}
