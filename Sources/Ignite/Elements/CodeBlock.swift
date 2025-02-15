//
// CodeBlock.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An separated section of programming code. For inline code that sit along other
/// text on your page, use `Code` instead.
///
/// - Important: If your code contains angle brackets (`<`...`>`), such as Swift generics,
/// the prettifier will interpret these as HTML tags and break the code's formatting.
/// To avoid this issue, either set your site’s `shouldPrettify` property to `false`,
/// or replace `<` and `>` with their character entity references, `&lt;` and `&gt;` respectively.
public struct CodeBlock: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString

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
