//
// ContentPreview.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol for customizing the layout of `ArticlePreview`.
public protocol ArticlePreviewStyle {
    func body(content: Article) -> any HTML
}

/// A wrapper around `Card`, specifically aimed at presenting details about
/// an article on your site. This automatically links to your article page
/// and adds in tags.
public struct ArticlePreview: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    var article: Article

    /// Custom style for the article preview.
    private var style: ArticlePreviewStyle?

    /// Initializes the article preview
    /// - Parameters:
    ///   - article: The article to display.
    public init(for article: Article) {
        self.article = article
    }

    public func articlePreviewStyle<S: ArticlePreviewStyle>(_ style: S) -> ArticlePreview {
        var copy = self
        copy.style = style
        return copy
    }

    /// Renders the article preview with either a custom layout or the default card.
    /// - Returns: A rendered string of HTML.
    public func render() -> String {
        // If custom style is provided, use it; otherwise,
        // fallback to default layout.
        if let style {
            style.body(content: article)
                .attributes(attributes)
                .render()
        } else {
            defaultCardLayout()
                .attributes(attributes)
                .render()
        }
    }

    /// Default card layout for rendering the article preview.
    /// - Returns: The article preview with the default card layout.
    private func defaultCardLayout() -> some HTML {
        Card(imageName: article.image) {
            Text(article.description)
                .margin(.bottom, .none)
        } header: {
            Text {
                Link(article)
            }
            .font(.title2)
        } footer: {
            let tagLinks = article.tagLinks()

            if let tagLinks {
                Section {
                    ForEach(tagLinks) { link in
                        link
                    }
                }
                .style(.marginTop, "-5px")
            }
        }
    }
}
