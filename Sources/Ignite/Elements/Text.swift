//
// Text.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import SwiftSoup

/// A structured piece of text, such as a paragraph of heading. If you are just
/// placing content inside a list, table, table header, and so on, you can usually
/// just use a simple string. Using `Text` is required if you want a specific paragraph
/// of text with some styling, or a header of a particular size.
///
/// - Important: For types that accept only `InlineElement` or use `@InlineElementBuilder`,
/// use `Span` instead of `Text`.
public struct Text: HTML, DropdownItem {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The font to use for this text.
    var font = FontStyle.body

    /// The content to place inside the text.
    private var content: any BodyElement

    /// Whether this text should wrap rendered markup in a container rather than a paragraph tag.
    private var wrapsBlockMarkup = false

    /// Creates a new `Text` instance using an inline element builder that
    /// returns an array of the content to place into the text.
    /// - Parameter content: An array of the content to place into the text.
    public init(@InlineElementBuilder content: () -> any InlineElement) {
        self.content = content()
    }

    /// Creates a new `Text` instance from one inline element.
    public init(_ string: any InlineElement) {
        self.content = string
    }

    /// Sets the maximum number of lines for the text to display.
    /// - Parameter number: The line limit. If `nil`, no line limit applies.
    /// - Returns: A new `Text` instance with the line limit applied.
    public func lineLimit(_ number: Int?) -> Self {
        var copy = self
        if let number {
            copy.attributes.append(classes: "ig-line-clamp")
            copy.attributes.append(styles: .init("--ig-max-line-length", value: number.formatted()))
        } else {
            copy.attributes.append(classes: "ig-line-clamp-none")
        }
        return copy
    }

    /// Creates a new `Text` instance using "lorem ipsum" placeholder text.
    /// - Parameter placeholderLength: How many placeholder words to generate.
    public init(placeholderLength: Int) {
        precondition(placeholderLength > 0, "placeholderLength must be at least 1.")

        let baseWords = ["Lorem", "ipsum", "dolor", "sit", "amet,", "consectetur", "adipiscing", "elit."]

        var finalWords: [String]

        if placeholderLength < baseWords.count {
            finalWords = Array(baseWords.prefix(placeholderLength))
        } else {
            let otherWords = [
                "ad", "aliqua", "aliquip", "anim", "aute", "cillum", "commodo", "consequat", "culpa", "cupidatat",
                "deserunt", "do", "dolor", "dolore", "duis", "ea", "eiusmod", "enim", "esse", "est", "et",
                "eu", "ex", "excepteur", "exercitation", "fugiat", "id", "in", "incididunt", "irure",
                "labore", "laboris", "laborum", "magna", "minim", "mollit", "nisi", "non", "nostrud", "nulla",
                "occaecat", "officia", "pariatur", "proident", "qui", "quis", "reprehenderit", "sed", "sint", "sunt",
                "tempor", "ullamco", "ut", "velit", "veniam", "voluptate"
            ]

            var isStartOfSentence = false
            finalWords = baseWords

            for _ in baseWords.count ..< placeholderLength {
                let randomWord = otherWords.randomElement() ?? "ad"
                var formattedWord = isStartOfSentence ? randomWord.capitalized : randomWord
                isStartOfSentence = false

                // Randomly add punctuation – 10% chance of adding
                // a comma, and 10% of adding a full stop instead.
                let punctuationProbability = Int.random(in: 1 ... 10)
                if punctuationProbability == 1 {
                    formattedWord.append(",")
                } else if punctuationProbability == 2 {
                    formattedWord.append(".")
                    isStartOfSentence = true
                }

                finalWords.append(formattedWord)
            }
        }

        var result = finalWords.joined(separator: " ").trimmingCharacters(in: .punctuationCharacters)
        result += "."

        self.content = result
    }

    /// Creates a new Text struct from a Markdown string.
    /// - Parameter markdown: The Markdown text to parse.
    public init(markdown: String) {
        let parser = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)
        let renderedMarkup = Self.renderedMarkupContent(from: parser.body)
        self.content = renderedMarkup.content
        self.wrapsBlockMarkup = renderedMarkup.wrapsBlockMarkup
    }

    /// Creates a new `Text` struct from a markup format and its parser.
    /// - Parameters:
    ///   - markup: The Markdown text to parse.
    ///   - parser: The parser to process the text.
    public init(markup: String, parser: any ArticleRenderer.Type) {
        do {
            let parser = try parser.init(markdown: markup, removeTitleFromBody: false)
            let renderedMarkup = Self.renderedMarkupContent(from: parser.body)
            self.content = renderedMarkup.content
            self.wrapsBlockMarkup = renderedMarkup.wrapsBlockMarkup
        } catch {
            self.content = markup
            publishingContext.addError(.failedToParseMarkup)
        }
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func markup() -> Markup {
        if wrapsBlockMarkup {
            // Block-level markup needs a container so the HTML stays valid and
            // modifiers continue to apply collectively rather than per child.
            Section(content)
                .attributes(attributes)
                .markup()
        } else {
            Markup(
                "<\(font.rawValue)\(attributes)>" +
                content.markupString() +
                "</\(font.rawValue)>"
            )
        }
    }
}

private extension Text {
    /// Decides whether parsed markup can be rendered inline or needs a block wrapper.
    static func renderedMarkupContent(from html: String) -> (content: any BodyElement, wrapsBlockMarkup: Bool) {
        guard let inlineMarkup = inlineMarkupContent(from: html) else {
            return (html, true)
        }

        return (inlineMarkup, false)
    }

    /// Extracts the contents of a single paragraph when the rendered markup contains nothing else.
    static func inlineMarkupContent(from html: String) -> String? {
        guard html.isEmpty == false else {
            return ""
        }

        guard
            let document = try? SwiftSoup.parseBodyFragment(html),
            let body = document.body()
        else {
            return nil
        }

        let children = body.children()

        guard
            body.childNodeSize() == 1,
            children.size() == 1,
            let paragraph = children.first(),
            paragraph.tagName() == "p"
        else {
            return nil
        }

        return try? paragraph.html()
    }
}

extension HTML {
    func fontStyle(_ font: Font.Style) -> any HTML {
        var copy: any HTML = self
        if Font.Style.classBasedStyles.contains(font), let sizeClass = font.sizeClass {
            copy.attributes.append(classes: sizeClass)
        } else if var text = copy as? Text {
            text.font = font
            copy = text
        } else if var anyHTML = copy as? AnyHTML, var text = anyHTML.wrapped as? Text {
            text.font = font
            anyHTML.wrapped = text
            copy = anyHTML
        }
        return copy
    }
}

extension InlineElement {
    func fontStyle(_ font: Font.Style) -> any InlineElement {
        var copy: any InlineElement = self
        copy.attributes.append(classes: font.sizeClass)
        return copy
    }
}
