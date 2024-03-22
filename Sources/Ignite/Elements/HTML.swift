//
// HTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// The top-level element of all web pages, containing one `Head` element
/// and one `Body` element.
public struct HTML: PageElement {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The headers for this page.
    var head: Head?

    /// The user-facing contents of this page.
    var body: Body?

    /// Creates a new `HTML` instance using a root element builder of objects.
    /// - Parameter contents: A root element builder that generates the array
    /// of `HTMLRootElement` objects to include on this page.
    public init(@HTMLRootElementBuilder contents: () -> [HTMLRootElement]) {
        for item in contents() {
            if let headItem = item as? Head {
                head = headItem
            } else if let bodyItem = item as? Body {
                body = bodyItem
            }
        }
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        var output = "<!doctype html>"
        output += "<html lang=\"\(context.site.language.rawValue)\" data-bs-theme=\"light\"\(attributes.description)>"
        output += head?.render(context: context) ?? ""
        output += body?.render(context: context) ?? ""

        output += Script(file: "/js/bootstrap.bundle.min.js").render(context: context)

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

        output += "</html>"

        return output
    }
}
