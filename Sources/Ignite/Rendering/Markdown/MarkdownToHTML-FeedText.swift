//
// MarkdownToHTML-FeedText.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Markdown

extension MarkdownToHTML {
    /// Extracts feed text from syntax nodes without decoding ordinary text a second time.
    /// Code remains literal; formatting, images, and hard breaks contribute no HTML tags.
    func feedText(for markup: Markdown.Markup) -> String {
        switch markup {
        case let code as Markdown.InlineCode:
            code.code
        case let text as Markdown.Text:
            text.plainText
        case let html as Markdown.InlineHTML:
            html.rawHTML.strippingTags()
        case is Markdown.Image, is Markdown.LineBreak:
            ""
        case is Markdown.SoftBreak:
            " "
        default:
            markup.children.map { feedText(for: $0) }.joined()
        }
    }
}
