//
// CodeBlock.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An separated section of programming code. For inline code that sit along other
/// text on your page, use `Code` instead.
public struct CodeBlock: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a grid.
    public var columnWidth = ColumnWidth.automatic

    /// The code to display.
    var content: String

    /// The language of the code being shown.
    var language: HighlighterLanguage?

    /// Creates a new `Code` instance from the given content.
    /// - Parameters:
    ///   - language: The programming language for the code. This affects
    ///   how the content is tagged, which in turn affects syntax highlighting.
    ///   - content: The code you want to render.
    public init(_ language: HighlighterLanguage? = nil, _ content: () -> String) {
        self.language = language
        self.content = content()
    }

    /// A code block with highlighted lines.
    /// - Parameter lines: Individual line numbers to highlight.
    /// - Returns: A copy of this code block with the specified lines highlighted.
    public func highlightedLines(_ lines: Int...) -> Self {
        var copy = self
        let lineCount = content.components(separatedBy: .newlines).count

        let highlights = lines.map { "\($0)" }
        let dataLine = highlights.joined(separator: ",")
        copy.attributes.append(dataAttributes: .init(name: "line", value: dataLine))
        return copy
    }

    /// A code block with highlighted line ranges.
    /// - Parameter ranges: Ranges of lines to highlight.
    /// - Returns: A copy of this code block with the specified line ranges highlighted.
    public func highlightedRanges(_ ranges: ClosedRange<Int>...) -> Self {
        var copy = self
        let lineCount = content.components(separatedBy: .newlines).count

        let highlights = ranges.map { "\($0.lowerBound)-\($0.upperBound)" }
        let dataLine = highlights.joined(separator: ",")
        copy.attributes.append(dataAttributes: .init(name: "line", value: dataLine))
        return copy
    }

    /// A code block with highlighted lines and ranges.
    /// - Parameters:
    ///   - lines: Individual line numbers to highlight.
    ///   - ranges: Ranges of lines to highlight.
    /// - Returns: A copy of this code block with the specified lines highlighted.
    public func highlightedLines(_ lines: Int..., ranges: ClosedRange<Int>...) -> Self {
        var copy = self
        let lineCount = content.components(separatedBy: .newlines).count

        let singleLines = lines.map { "\($0)" }
        let rangeLines = ranges.map { "\($0.lowerBound)-\($0.upperBound)" }
        let allHighlights = singleLines + rangeLines

        let dataLine = allHighlights.joined(separator: ",")
        copy.attributes.append(dataAttributes: .init(name: "line", value: dataLine))
        return copy
    }

    /// Configures whether line numbers are shown for this code block.
    /// - Parameter visibility: The visibility configuration for line numbers,
    /// including start line and text wrapping options.
    /// - Returns: A copy of this code block with the specified line number visibility.
    public func lineNumberVisibility(_ visibility: SyntaxHighlighterConfiguration.LineNumberVisibility) -> Self {
        var copy = self

        let siteVisibility = publishingContext.site.syntaxHighlighterConfiguration.lineNumberVisibility

        switch (siteVisibility, visibility) {
        case (.visible, .hidden):
            copy.attributes.append(classes: "no-line-numbers")

        case (.hidden, .visible(let elementFirstLine, let elementWrapped)):
            copy.attributes.append(classes: "line-numbers")

            if elementFirstLine != 1 {
                copy.attributes.append(dataAttributes: .init(name: "start", value: elementFirstLine.formatted()))
            }
            if elementWrapped {
                copy.attributes.append(styles: .init(.whiteSpace, value: "pre-wrap"))
            }

        case (.visible(let siteFirstLine, let siteWrapped), .visible(let elementFirstLine, let elementWrapped)):
            if elementFirstLine != siteFirstLine {
                copy.attributes.append(dataAttributes: .init(name: "start", value: elementFirstLine.formatted()))
            }
            if elementWrapped != siteWrapped {
                copy.attributes.append(styles: .init(.whiteSpace, value: elementWrapped ? "pre-wrap" : "pre"))
            }

        default:
            break
        }

        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        guard publishingContext.site.allHighlighterThemes.isEmpty == false else {
            fatalError(.missingDefaultSyntaxHighlighterTheme)
        }

        if let language {
            publishingContext.syntaxHighlighters.append(language)
            return """
            <pre\(attributes.description())>\
            <code class=\"language-\(language)\">\
            \(content)\
            </code>\
            </pre>
            """
        } else {
            return """
            <pre\(attributes.description())>\
            <code>\(content)</code>\
            </pre>
            """
        }
    }
}
