//
// Body.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// The main, user-visible contents of your page.
public struct Body: PageElement, HTMLRootElement {
    public var attributes = CoreAttributes()

    var items: [BaseElement]

    public init(@ElementBuilder<BaseElement> _ items: () -> [BaseElement]) {
        self.items = items()
    }

    public init(for page: Page) {
        self.items = [page.body]
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        var output = Group {
            for item in items {
                item
            }
        }
        .class("col-sm-\(context.site.pageWidth)", "mx-auto")
        .render(context: context)

        if context.site.useDefaultBootstrapURLs == .localBootstrap {
            output += Script(file: "/js/bootstrap.bundle.min.js").render(context: context)
        } else if context.site.useDefaultBootstrapURLs == .remoteBootstrap {
            output += Script(file: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js")
                                .addCustomAttribute(name: "integrity", value: "sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy")
                                .addCustomAttribute(name: "crossorigin", value: "anonymous")
                                .render(context: context)
        }
        
        if context.site.useDefaultManifestURL == .localManifest {
            output += Script(file: "/js/manifest.json").render(context: context)
        }
        
        if context.site.syntaxHighlighters.isEmpty == false {
            output += Script(file: "/js/syntax-highlighting.js").render(context: context)
        }

        // Activate tooltips if there are any.
        if output.contains(#"data-bs-toggle="tooltip""#) {
            output += Script(code: """
            const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
            const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))
            """).render(context: context)
        }

        return "<body\(attributes.description)>\(output)</body>"
    }
}
