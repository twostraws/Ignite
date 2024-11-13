//
// MarkdownToHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Markdown

/// A simple Markdown to HTML parser powered by Apple's swift-markdown.
public struct MarkdownToHTML: MarkdownRenderer, MarkupVisitor {
    /// The title of this document.
    public var title = ""

    /// The description of this document, which is the first paragraph.
    public var description = ""

    /// The body text of this file, which includes its title by default.
    public var body = ""

    /// Whether to remove the Markdown title from its body. This only applies
    /// to the first heading.
    public var removeTitleFromBody: Bool

    /// A dictionary of metadata specified at the top of the file as YAML front matter.
    /// See https://jekyllrb.com/docs/front-matter/ for information.
    public var metadata = [String: String]()

    /// Parses Markdown provided as a direct input string.
    /// - Parameters:
    ///   - markdown: The Markdown to parse.
    ///   - removeTitleFromBody: True if the first title should be removed
    ///   from the final `body` property.
    public init(markdown: String, removeTitleFromBody: Bool) {
        self.removeTitleFromBody = removeTitleFromBody
        let processed = processMetadata(for: markdown)
        let document = Document(parsing: processed)
        body = visit(document)
    }

    /// Parses Markdown provided from a filesystem URL.
    /// - Parameters:
    ///   - url: The filesystem URL to load.
    ///   - removeTitleFromBody: True if the first title should be removed
    ///   from the final `body` property.
    public init(url: URL, removeTitleFromBody: Bool) throws {
        self.removeTitleFromBody = removeTitleFromBody
        var markdown: String
        do {
            markdown = try String(contentsOf: url)
        } catch {
            throw PublishingError.unopenableFile(error.localizedDescription)
        }
        do {
            let processed = processMetadata(for: markdown)
            let document = Document(parsing: processed)
            body = visit(document)

            if title.isEmpty {
                // Assign a title that's better than the default empty string.
                title = url.deletingPathExtension().lastPathComponent
            }
            if false { throw PublishingError.badMarkdown(url) } // to silence "'catch' block is unreachable" warning
        } catch {
            throw PublishingError.badMarkdown(url)
        }
    }

    /// Looks for and parses any YAML front matter from this Markdown.
    /// - Parameter markdown: The Markdown string to process.
    /// - Returns: The remaining Markdown, once front matter has been removed.
    private mutating func processMetadata(for markdown: String) -> String {
        if markdown.starts(with: "---") {
            let parts = markdown.split(separator: "---", maxSplits: 1, omittingEmptySubsequences: true)

            let header = parts[0].split(separator: "\n", omittingEmptySubsequences: true)

            for entry in header {
                let entryParts = entry.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
                guard entryParts.count == 2 else { continue }

                let trimmedValue = entryParts[1].trimmingCharacters(in: .whitespaces)
                metadata[entryParts[0].trimmingCharacters(in: .whitespaces)] = trimmedValue
            }

            return String(parts[1].trimmingCharacters(in: .whitespacesAndNewlines))
        } else {
            return markdown
        }
    }

    /// Visit some markup when no other handler is suitable.
    /// - Parameter markup: The markup that is being processed.
    /// - Returns: A string to append to the output.
    mutating public func defaultVisit(_ markup: Markdown.Markup) -> String {
        var result = ""

        for child in markup.children {
            result += visit(child)
        }

        return result
    }

    /// Processes block quote markup.
    /// - Parameter blockQuote: The block quote data to process.
    /// - Returns: A HTML <blockquote> element with the block quote's children inside.
    mutating public func visitBlockQuote(_ blockQuote: Markdown.BlockQuote) -> String {
        var result = "<blockquote>"

        for child in blockQuote.children {
            result += visit(child)
        }

        result += "</blockquote>"
        return result
    }

    /// Processes code block markup.
    /// - Parameter codeBlock: The code block to process.
    /// - Returns: A HTML <pre> element with <code> inside, marked with
    /// CSS to remember which language was used.
    public func visitCodeBlock(_ codeBlock: Markdown.CodeBlock) -> String {
        if let language = codeBlock.language {
            #"<pre><code class="language-\#(language.lowercased())">\#(codeBlock.code)</code></pre>"#
        } else {
            #"<pre><code>\#(codeBlock.code)</code></pre>"#
        }
    }

    /// Processes soft breaks (single newlines).
    /// - Parameter softBreak: The soft break to process.
    /// - Returns: A single space.
    public func visitSoftBreak(_ softBreak: SoftBreak) -> String {
        return " "
    }

    /// Processes emphasis markup.
    /// - Parameter emphasis: The emphasized content to process.
    /// - Returns: A HTML <em> element with the markup's children inside.
    mutating public func visitEmphasis(_ emphasis: Markdown.Emphasis) -> String {
        var result = "<em>"

        for child in emphasis.children {
            result += visit(child)
        }

        result.append("</em>")
        return result
    }

    /// Processes heading markup.
    /// - Parameter heading: The heading to process.
    /// - Returns: A HTML <h*> element with its children inside. The exact
    /// heading level depends on the markup. If this is our first heading, we use it
    /// for the document title.
    mutating public func visitHeading(_ heading: Markdown.Heading) -> String {
        var headingContent = ""

        for child in heading.children {
            headingContent += visit(child)
        }

        // If we don't already have a document title, use this as the document's title.
        if title.isEmpty {
            title = headingContent

            // If we've been asked to strip out the title from
            // the rendered body, send back nothing here.
            if removeTitleFromBody {
                return ""
            }
        }

        return "<h\(heading.level)>\(headingContent)</h\(heading.level)>"
    }

    /// Processes a block of HTML markup.
    /// - Parameter html: The HTML to process.
    /// - Returns: The raw HTML as-is.
    public func visitHTMLBlock(_ html: Markdown.HTMLBlock) -> String {
        html.rawHTML
    }

    /// Process image markup.
    /// - Parameter image: The image markup to process.
    /// - Returns: A HTML <img> tag with its source set correctly. This also
    /// appends Bootstrap's `img-fluid` CSS class so that images resize.
    public func visitImage(_ image: Markdown.Image) -> String {
        if let source = image.source {
            let title = image.plainText
            return #"<img src="\#(source)" alt="\#(title)" class="img-fluid">"#
        } else {
            return ""
        }
    }

    /// Process inline code markup.
    /// - Parameter inlineCode: The inline code markup to process.
    /// - Returns: A HTML <code> tag containing the code.
    mutating public func visitInlineCode(_ inlineCode: Markdown.InlineCode) -> String {
        "<code>\(inlineCode.code)</code>"
    }

    /// Processes a chunk of inline HTML markup.
    /// - Parameter inlineHTML: The HTML markup to process.
    /// - Returns: The raw HTML as-is.
    public func visitInlineHTML(_ inlineHTML: Markdown.InlineHTML) -> String {
        inlineHTML.rawHTML
    }

    /// Processes hyperlink markup.
    /// - Parameter link: The link markup to process.
    /// - Returns: Returns a HTML <a> tag with the correct location and content.
    mutating public func visitLink(_ link: Markdown.Link) -> String {
        var result = #"<a href="\#(link.destination ?? "#")">"#

        for child in link.children {
            result += visit(child)
        }

        result += "</a>"
        return result
    }

    /// Processes one item from a list.
    /// - Parameter listItem: The list item markup to process.
    /// - Returns: A HTML <li> tag containing the list item's contents.
    mutating public func visitListItem(_ listItem: Markdown.ListItem) -> String {
        var result = "<li>"

        for child in listItem.children {
            result += visit(child)
        }

        result += "</li>"
        return result
    }

    /// Processes unordered list markup.
    /// - Parameter orderedList: The unordered list markup to process.
    /// - Returns: A HTML <ol> element with the correct contents.
    mutating public func visitOrderedList(_ orderedList: Markdown.OrderedList) -> String {
        var result = "<ol>"

        for listItem in orderedList.listItems {
            result += visit(listItem)
        }

        result += "</ol>"
        return result
    }

    /// Processes a paragraph of text.
    /// - Parameter paragraph: The paragraph markup to process.
    /// - Returns: If we're inside a list this sends back the paragraph's
    /// contents directly. Otherwise, it wraps the contents in a HTML <p> element.
    /// If this is the first paragraph of text in the document we use it for the
    /// description of this document.
    mutating public func visitParagraph(_ paragraph: Markdown.Paragraph) -> String {
        var result = ""
        var paragraphContents = ""

        if paragraph.isInsideList == false {
            result += "<p>"
        }

        for child in paragraph.children {
            paragraphContents += visit(child)
        }

        result += paragraphContents

        if description.isEmpty {
            description = paragraphContents
        }

        if paragraph.isInsideList == false {
            result += "</p>"
        }

        return result
    }

    /// Processes some strikethrough markup.
    /// - Parameter strikethrough: The strikethrough markup to process.
    /// - Returns: Content wrapped inside a HTML <s> element.
    mutating public func visitStrikethrough(_ strikethrough: Markdown.Strikethrough) -> String {
        var result = "<s>"

        for child in strikethrough.children {
            result += visit(child)
        }

        result += "</s>"

        return result
    }

    /// Processes some strong markup.
    /// - Parameter strong: The strong markup to process.
    /// - Returns: Content wrapped inside a HTML <strong> element.
    mutating public func visitStrong(_ strong: Markdown.Strong) -> String {
        var result = "<strong>"

        for child in strong.children {
            result += visit(child)
        }

        result += "</strong>"
        return result
    }

    /// Processes table markup.
    /// - Parameter table: The table markup to process.
    /// - Returns: A HTML <table> element, optionally with <thead> and
    /// <tbody> if they are provided.
    public mutating func visitTable(_ table: Markdown.Table) -> String {
        var output = "<table>"

        if table.head.childCount > 0 {
            output += "<thead>"
            output += visit(table.head)
            output += "</thead>"
        }

        if table.body.childCount > 0 {
            output += "<tbody>"
            output += visit(table.body)
            output += "</tbody>"
        }

        output += "</table>"
        return output
    }

    /// Processes table head markup.
    /// - Parameter tableHead: The table head markup to process.
    /// - Returns: A string containing zero or more HTML <th> elements
    /// representing the headers in this table.
    public mutating func visitTableHead(_ tableHead: Markdown.Table.Head) -> String {
        var output = ""

        for child in tableHead.children {
            output += "<th>"
            output += visit(child)
            output += "</th>"
        }

        return output
    }

    /// Processes table row markup.
    /// - Parameter tableRow: The table head markup to process.
    /// - Returns: A string containing zero or more HTML <tr> elements
    /// representing the rows in this table, with each row containing zero or
    /// more <td> elements for each column processed.
    public mutating func visitTableRow(_ tableRow: Markdown.Table.Row) -> String {
        var output = "<tr>"

        for child in tableRow.children {
            output += "<td>"
            output += visit(child)
            output += "</td>"

        }

        output += "</tr>"
        return output
    }

    /// Processes plain text markup.
    /// - Parameter text: The plain text markup to process.
    /// - Returns: The same text that was read as input.
    mutating public func visitText(_ text: Markdown.Text) -> String {
        text.plainText
    }

    /// Process thematic break markup. This is written as --- in Markdown.
    /// - Parameter thematicBreak: The thematic break markup to process.
    /// - Returns: A HTML <hr> element.
    public func visitThematicBreak(_ thematicBreak: Markdown.ThematicBreak) -> String {
        "<hr />"
    }

    /// Processes ordered list markup.
    /// - Parameter orderedList: The ordered list markup to process.
    /// - Returns: A HTML <ul> element with the correct contents.
    public mutating func visitUnorderedList(_ unorderedList: Markdown.UnorderedList) -> String {
        var result = "<ul>"

        for listItem in unorderedList.listItems {
            result += visit(listItem)
        }

        result += "</ul>"
        return result
    }
}

extension Markup {
    /// A small helper that determines whether this markup or any parent is a list.
    var isInsideList: Bool {
        self is ListItemContainer || parent?.isInsideList == true
    }
}
