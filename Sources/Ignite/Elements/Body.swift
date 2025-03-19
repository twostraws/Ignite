//
// Body.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public struct Body: DocumentElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// Whether this HTML uses Bootstrap's `container` class to determine page width.
    var isBoundByContainer: Bool = true

    var content: any HTML

    public init(@HTMLBuilder _ content: () -> some HTML) {
        self.content = content()
    }

    public init() {
        let pageContent = PublishingContext.shared.environment.pageContent
        self.content = pageContent
    }

    /// Removes the Bootstrap `container` class from the body element.
    ///
    /// By default, the body element uses Bootstrap's container class to provide consistent page margins.
    /// Call this method when you want content to extend to the full width of the viewport.
    ///
    /// - Returns: A copy of the current element that ignores page gutters.
    public func ignorePageGutters() -> Self {
        var copy = self
        copy.isBoundByContainer = false
        return copy
    }

    public func render() -> String {
        var attributes = attributes
        var output = content.render()

        // Add required scripts
        if publishingContext.site.useDefaultBootstrapURLs == .localBootstrap {
            output += Script(file: "/js/bootstrap.bundle.min.js").render()
        }

        if publishingContext.hasSyntaxHighlighters == true {
            output += Script(file: "/js/syntax-highlighting.js").render()
        }

        if case .visible(let firstLine, let shouldWrap) =
            publishingContext.site.syntaxHighlighterConfiguration.lineNumberVisibility {

            attributes.append(classes: "line-numbers")
            if firstLine != 1 {
                attributes.append(dataAttributes: .init(name: "start", value: firstLine.formatted()))
            }
            if shouldWrap {
                attributes.append(styles: .init(.whiteSpace, value: "pre-wrap"))
            }
        }

        if output.contains(#"data-bs-toggle="tooltip""#) {
            output += Script(code: """
            const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
            const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))
            """).render()
        }

        output += Script(file: "/js/ignite-core.js").render()

        if isBoundByContainer {
            attributes.append(classes: ["container"])
        }
        return "<body\(attributes)>\(output)</body>"
    }
}
