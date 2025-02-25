//
// PublishingContext-Rendering.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension PublishingContext {
    /// Renders a static page.
    /// - Parameters:
    ///   - page: The page to render.
    ///   - isHomePage: True if this is your site's homepage; this affects the
    ///   final path that is written to.
    func render(_ staticLayout: any StaticLayout, isHomePage: Bool = false) {
        let path = isHomePage ? "" : staticLayout.path
        currentRenderingPath = isHomePage ? "/" : staticLayout.path

        let metadata = PageMetadata(
            title: staticLayout.title,
            description: staticLayout.description,
            url: site.url.appending(path: path),
            image: staticLayout.image
        )

        let values = EnvironmentValues(
            sourceDirectory: sourceDirectory,
            site: site,
            allContent: allContent,
            pageMetadata: metadata,
            pageContent: staticLayout)

        let outputString = withEnvironment(values) {
            staticLayout.parentLayout.body.render()
        }

        let outputDirectory = buildDirectory.appending(path: path)
        write(outputString, to: outputDirectory, priority: isHomePage ? 1 : 0.9)
    }

    /// Renders one piece of Markdown content.
    /// - Parameter content: The content to render.
    func render(_ article: Article) {
        let layout = layout(for: article)
        currentRenderingPath = article.path

        let metadata = PageMetadata(
            title: article.title,
            description: article.description,
            url: site.url.appending(path: article.path),
            image: article.image.flatMap { URL(string: $0) }
        )

        let values = EnvironmentValues(
            sourceDirectory: sourceDirectory,
            site: site,
            allContent: allContent,
            pageMetadata: metadata,
            pageContent: layout,
            article: article)

        let outputString = withEnvironment(values) {
            layout.parentLayout.body.render()
        }

        let outputDirectory = buildDirectory.appending(path: article.path)
        write(outputString, to: outputDirectory, priority: 0.8)
    }

    /// Generates all tags pages, including the "all tags" page.
    func renderTagLayouts() async {
        if site.tagLayout is EmptyTagLayout { return }

        /// Creates a unique list of sorted tags from across the site, starting
        /// with `nil` for the "all tags" page.
        let tags: [String?] = [nil] + Set(allContent.flatMap(\.tags)).sorted()

        for tag in tags {
            let path: String = if let tag {
                "tags/\(tag.convertedToSlug() ?? tag)"
            } else {
                "tags"
            }

            let outputDirectory = buildDirectory.appending(path: path)
            let tagLayout = site.tagLayout

            let metadata = PageMetadata(
                title: "Tags",
                description: "Tags",
                url: site.url.appending(path: path)
            )

            let values = EnvironmentValues(
                sourceDirectory: sourceDirectory,
                site: site,
                allContent: allContent,
                pageMetadata: metadata,
                pageContent: tagLayout,
                tag: tag,
                taggedContent: content(tagged: tag))

            let outputString = withEnvironment(values) {
                tagLayout.parentLayout.body.render()
            }

            write(outputString, to: outputDirectory, priority: tag == nil ? 0.7 : 0.6)
        }
    }

    /// Locates the best layout to use for a piece of Markdown content. Layouts
    /// are specified using YAML front matter, but if none are found then the first
    /// layout in your site's `layouts` property is used.
    /// - Parameter content: The content that is being rendered.
    /// - Returns: The correct `ContentPage` instance to use for this content.
    func layout(for article: Article) -> any ArticleLayout {
        if let contentLayout = article.layout {
            for layout in site.articleLayouts {
                let layoutName = String(describing: type(of: layout))

                if layoutName == contentLayout {
                    return layout
                }
            }

            fatalError(.missingNamedLayout(contentLayout))
        } else if let defaultLayout = site.articleLayouts.first {
            return defaultLayout
        } else {
            fatalError(.missingDefaultLayout)
        }
    }
}
