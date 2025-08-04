//
// Span.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An inline subsection of another element, useful when you need to style
/// just part of some text, for example.
public struct Span<Content: InlineElement>: InlineElement, NavigationElement, ControlGroupElement {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The content of this span.
    private var content: Content

    /// How a `NavigationBar` displays this item at different breakpoints.
    public var navigationBarVisibility: NavigationBarVisibility = .automatic

    /// Creates a span with no content. Used in some situations where
    /// exact styling is performed by Bootstrap, e.g. in Carousel.
    public init() where Content == EmptyInlineElement {
        self.content = EmptyInlineElement()
    }

    /// Creates a span from one `InlineElement`.
    /// - Parameter singleElement: The element you want to place
    /// inside the span.
    public init(_ singleElement: Content) {
        self.content = singleElement
    }

    /// Creates a span from an inline element builder that returns an array of
    /// elements to place inside the span.
    /// - Parameter contents: The elements to place inside the span.
    public init(@InlineElementBuilder content: () -> Content) {
        self.content = content()
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        let contentHTML = content.markupString()
        return Markup("<span\(attributes)>\(contentHTML)</span>")
    }
}

extension Span: NavigationElementRenderable {
    func renderAsNavigationElement() -> Markup {
        var copy = self
        copy.attributes.append(classes: "navbar-text")
        return copy.render()
    }
}

extension Span: FormElementRenderable {
    func renderAsFormElement(_ configuration: FormConfiguration) -> Markup {
        print("""
        For proper alignment within Form, prefer a read-only, \
        plain-text TextField over a Span.
        """)

        return Section(InlineHTML(self))
            .class("d-flex", "align-items-center")
            .render()
    }
}

extension Span: ControlGroupItemConfigurable {
    func configuredAsControlGroupItem(_ labelStyle: ControlLabelStyle) -> ControlGroupItem {
        ControlGroupItem(self.class("input-group-text"))
    }
}
