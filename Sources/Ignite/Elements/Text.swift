//
// Text.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A structured piece of text, such as a paragraph of heading. If you are just
/// placing content inside a list, table, table header, and so on, you can usually
/// just use a simple string. Using `Text` is required if you want a specific paragraph
/// of text with some styling, or a header of a particular size.
///
/// - Important: For types that accept only `InlineElement` or use `@InlineElementBuilder`,
/// use `Span` instead of `Text`.
@MainActor
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
    var content: any BodyElement

    private var isMultilineMarkdown = false

    /// Creates a new `Text` instance using an inline element builder that
    /// returns an array of the content to place into the text.
    /// - Parameter content: An array of the content to place into the text.
    public init(@InlineElementBuilder content: @escaping () -> any InlineElement) {
        self.content = content()
    }

    /// Creates a new `Text` instance from one inline element.
    public init(_ string: any InlineElement) {
        self.content = string
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
        // Process each paragraph individually to preserve line breaks.
        // We could simply replace newlines with <br>, but then the paragraphs
        // wouldn't respond to a theme's paragraphBottomMargin property.
        let paragraphs = markdown.components(separatedBy: .newlines)
            .filter { !$0.isEmpty }

        let processedParagraphs = paragraphs.map {
            let parser = MarkdownToHTML(markdown: $0, removeTitleFromBody: true)
            return parser.body.replacing(#/<\/?p>/#, with: "")
        }

        // If single paragraph, use directly; otherwise create HTMLCollection
        self.content = processedParagraphs.count == 1
            ? processedParagraphs[0]
            : HTMLCollection(processedParagraphs.map(Text.init))

        self.isMultilineMarkdown = processedParagraphs.count > 1
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func markup() -> Markup {
        if isMultilineMarkdown {
            // HTMLCollection will pass its attributes to each child.
            // This works fine for styles like color, but for styles like
            // padding, we'd expect them to apply to the paragraphs
            // collectively. So we'll wrap the paragraphs in a Section.
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
