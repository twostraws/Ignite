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
    func render(_ page: any StaticPage) {
        render(page, rootPath: page.path, pagePath: page.path)
    }

    func render(homePage: any StaticPage) {
        render(homePage, rootPath: "/", pagePath: "", priority: 1)
    }

    /// Renders a static page.
    /// - Parameters:
    ///   - page: The page to render.
    ///   - rootPath: The root path to render the page to.
    ///   - pagePath: The path to render the page to.
    ///   - priority: The priority of this page in the sitemap. Defaults to `0.9`.
    ///   - filename: The filename to use for the rendered page. Defaults to `index`.
    func render(
        _ page: any StaticPage,
        rootPath: String,
        pagePath: String,
        priority: Double? = 0.9,
        filename: String = "index"
    ) {
        let path = pagePath
        currentRenderingPath = rootPath
        let metadata = PageMetadata(
            title: page.title,
            description: page.description,
            url: site.url.appending(path: path),
            image: page.image
        )

        let values = EnvironmentValues(
            sourceDirectory: sourceDirectory,
            site: site,
            allContent: allContent,
            pageMetadata: metadata,
            pageContent: page)

        let outputString = withEnvironment(values) {
            page.layout.body.render()
        }

        let outputDirectory = buildDirectory.appending(path: path)
        write(outputString, to: outputDirectory, priority: priority, filename: filename)
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
            layout.layout.body.render()
        }

        let outputDirectory = buildDirectory.appending(path: article.path)
        write(outputString, to: outputDirectory, priority: 0.8)
    }

    /// Generates all tags pages, including the "all tags" page.
    func renderTagPages() async {
        if site.tagPage is EmptyTagPage { return }

        /// Creates a unique list of sorted tags from across the site, starting
        /// with `nil` for the "all tags" page.
        let tags: [String?] = [nil] + Set(allContent.compactMap(\.tags).flatMap(\.self)).sorted()

        for tag in tags {
            let path: String = if let tag {
                "tags/\(tag.convertedToSlug())"
            } else {
                "tags"
            }

            let outputDirectory = buildDirectory.appending(path: path)
            let tagLayout = site.tagPage

            let metadata = PageMetadata(
                title: "Tags",
                description: "Tags",
                url: site.url.appending(path: path)
            )

            let category: any Category = if let tag {
                TagCategory(name: tag, articles: content(tagged: tag))
            } else {
                AllTagsCategory(articles: content(tagged: nil))
            }

            let values = EnvironmentValues(
                sourceDirectory: sourceDirectory,
                site: site,
                allContent: allContent,
                pageMetadata: metadata,
                pageContent: tagLayout,
                category: category)

            let outputString = withEnvironment(values) {
                tagLayout.layout.body.render()
            }

            write(outputString, to: outputDirectory, priority: tag == nil ? 0.7 : 0.6)
        }
    }

    func renderErrorPages() async {
        if site.errorPage is EmptyErrorPage { return }

        for error in [PageNotFoundError()] {
            environment.httpError = error

            let metadata = PageMetadata(
                title: site.errorPage.title,
                description: site.errorPage.description,
                url: site.url
            )

            let values = EnvironmentValues(
                sourceDirectory: sourceDirectory,
                site: site,
                allContent: allContent,
                pageMetadata: metadata,
                pageContent: site.errorPage)

            let outputString = withEnvironment(values) {
                site.errorPage.layout.body.render()
            }

            write(outputString, to: buildDirectory, priority: nil, filename: String(error.statusCode))
        }

        environment.httpError = EmptyHTTPError()
    }

    /// Locates the best layout to use for a piece of Markdown content. Layouts
    /// are specified using YAML front matter, but if none are found then the first
    /// layout in your site's `layouts` property is used.
    /// - Parameter content: The content that is being rendered.
    /// - Returns: The correct `ContentPage` instance to use for this content.
    func layout(for article: Article) -> any ArticlePage {
        if let contentLayout = article.layout {
            for layout in site.articlePages {
                let layoutName = String(describing: type(of: layout))

                if layoutName == contentLayout {
                    return layout
                }
            }

            fatalError(.missingNamedLayout(contentLayout))
        } else if let defaultLayout = site.articlePages.first {
            return defaultLayout
        } else {
            fatalError(.missingDefaultLayout)
        }
    }
}
