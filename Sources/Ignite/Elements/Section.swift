//
// Section.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container element that groups its children together.
///
/// When initialized with just content, the section wraps its children in a `<div>`.
/// When initialized with a header and content, the section wraps its children in a `<section>`.
///
/// - Note: Unlike ``Group``, modifiers applied to a `Section` affect the
///         containing element rather than being propagated to child elements.
@MainActor
public struct Section<Content> {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The heading text of the section.
    private var header: String?

    /// The heading's semantic font size.
    private var headerStyle: Font.Style = .title2

    /// The content of the section.
    private var content: Content
}

extension Section: HTML, Sendable, FormElementRenderable where Content: HTML {
    /// Creates a section that renders as a `div` element.
    /// - Parameter content: The content to display within this section.
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }

    /// Creates a section that renders as a `section` element with a heading.
    /// - Parameters:
    ///   - header: The text to display as the section's heading
    ///   - content: The content to display within this section
    public init(_ header: String, @HTMLBuilder content: () -> Content) {
        self.content = content()
        self.header = header
    }

    init(_ content: Content) {
        self.content = content
    }

    init() where Content == EmptyHTML {
        self.content = EmptyHTML()
    }

    init<T: InlineElement>(_ content: T) where Content == InlineHTML<T> {
        self.content = InlineHTML(content)
    }

    /// Adjusts the semantic importance of the section's header by changing its font style.
    /// - Parameter fontStyle: The font style to apply to the header
    /// - Returns: A section with the modified header style
    public func headerProminence(_ fontStyle: Font.Style) -> Self {
        var copy = self
        copy.headerStyle = fontStyle
        return copy
    }

    public func render() -> Markup {
        let contentHTML = content.markupString()
        if let header = header {
            let headerHTML = Text(header).font(headerStyle).markupString()
            return Markup("<section\(attributes)>\(headerHTML + contentHTML)</section>")
        }
        return Markup("<div\(attributes)>\(contentHTML)</div>")
    }

    func renderAsFormElement(_ configuration: FormConfiguration) -> Markup {
        var subviews = content.subviews().elements
        let last = subviews.last

        subviews = subviews.dropLast().map {
            var subview = $0
            subview.attributes.append(classes: "mb-\(configuration.spacing.rawValue)")
            return subview
        }

        if let last {
            subviews.append(last)
        }

        return Tag("fieldset") {
            if let header {
                Tag("legend") { header }
                    .class(configuration.labelStyle == .leading ? "col-form-label col-sm-2" : nil)
            }

            ForEach(subviews) { item in
                FormItem(item)
                    .formConfiguration(configuration)
            }
        }
        .render()
    }
}
