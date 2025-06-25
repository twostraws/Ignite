//
// FontModifiedHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A wrapper that applies font styling to HTML content.
struct FontModifiedHTML<Content: HTML>: HTML {
    var body: Never { fatalError() }
    var attributes = CoreAttributes()

    private var content: Content
    private var font: Font

    /// Creates a font-modified HTML element.
    /// - Parameters:
    ///   - content: The HTML content to style.
    ///   - font: The font configuration to apply.
    init(_ content: Content, font: Font) {
        self.content = content
        self.font = font
    }

    /// Renders the font-styled content as markup.
    /// - Returns: The rendered markup with font attributes applied.
    func render() -> Markup {
        let attributes = FontModifier.attributes(for: font, includeStyle: true)
        return Section(content.class("font-inherit"))
            .attributes(attributes)
            .render()
    }
}
