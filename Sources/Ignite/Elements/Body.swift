//
// Body.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public struct Body: MarkupElement {
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

    public func render() -> Markup {
        var attributes = attributes
        var output = content.render()

        if publishingContext.site.useDefaultBootstrapURLs == .localBootstrap {
            output += Script(file: "/js/bootstrap.bundle.min.js").render()
        } else if
            let url = URL(string: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js") {
            output += Script(file: url)
                .customAttribute(
                    name: "integrity",
                    value: "sha384-k6d4wzSIapyDyv1kpU366/PK5hCdSbCRGRCMv+eplOQJWyd1fbcAu9OCUj5zNLiq")
                .customAttribute(name: "crossorigin", value: "anonymous")
                .render()
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

        if output.string.contains(#"data-bs-toggle="tooltip""#) {
            output += Script(code: """
            const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
            const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))
            """).render()
        }

        output += Script(file: "/js/ignite-core.js").render()

        if isBoundByContainer {
            attributes.append(classes: ["container"])
        }
        return Markup("<body\(attributes)>\(output.string)</body>")
    }
}

public extension Body {
    /// Adds a data attribute to the element.
    /// - Parameters:
    ///   - name: The name of the data attribute
    ///   - value: The value of the data attribute
    /// - Returns: The modified `Body` element
    func data(_ name: String, _ value: String) -> Self {
        var copy = self
        copy.attributes.data.append(.init(name: name, value: value))
        return copy
    }

    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func customAttribute(name: String, value: String) -> Self {
        var copy = self
        copy.attributes.append(customAttributes: .init(name: name, value: value))
        return copy
    }
}

public extension Body {
    /// Applies margins on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - length: The amount of margin to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ length: LengthUnit) -> Self {
        let styles = edges.styles(prefix: "margin", length: length.stringValue)
        var copy = self
        copy.attributes.append(styles: styles)
        return copy
    }

    /// Applies margins on selected sides of this element, using adaptive sizing.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - amount: The amount of margin to apply, specified as a
    ///   `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ amount: SemanticSpacing) -> Self {
        let classes = edges.classes(prefix: "m", amount: amount.rawValue)
        var copy = self
        copy.attributes.append(classes: classes)
        return copy
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: LengthUnit) -> Self {
        let styles = edges.styles(prefix: "padding", length: length.stringValue)
        var copy = self
        copy.attributes.append(styles: styles)
        return copy
    }

    /// Applies padding on selected sides of this element using adaptive sizing.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ amount: SemanticSpacing) -> Self {
        let classes = edges.classes(prefix: "p", amount: amount.rawValue)
        var copy = self
        copy.attributes.append(classes: classes)
        return copy
    }
}
