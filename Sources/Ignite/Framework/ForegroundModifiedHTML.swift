//
// ForegroundModifiedHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that applies foreground styling to HTML content.
struct ForegroundModifiedHTML<Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The HTML content to be styled.
    private var content: Content

    /// The foreground style to apply to the content.
    private var style: ForegroundStyleType

    /// Creates a foreground-modified HTML element.
    /// - Parameters:
    ///   - content: The HTML content to apply foreground styling to.
    ///   - style: The type of foreground style to apply.
    init(_ content: Content, style: ForegroundStyleType) {
        self.content = content
        self.style = style
    }

    func render() -> Markup {
        var content = content
        content.attributes.merge(attributes)
        return switch style {
        case .none: content.render()
        case .gradient(let gradient):
            Section(content.class("color-inherit"))
                .style(gradient.styles)
                .render()
        case .string(let string):
            Section(content.class("color-inherit"))
                .style(.color, string)
                .render()
        case .color(let color):
            Section(content.class("color-inherit"))
                .style(.color, color.description)
                .render()
        case .style(let style):
            Section(content.class("color-inherit"))
                .style(.color, style.rawValue)
                .render()
        }
    }
}
