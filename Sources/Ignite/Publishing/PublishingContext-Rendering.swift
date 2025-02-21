//
// PublishingContext-Rendering.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension PublishingContext {
    /// Renders one static page using the correct theme, which is taken either from the
    /// provided them or from the main site theme.
    func render(_ page: Page, using layout: any Layout) -> String {
        let finalLayout: any Layout

        if layout is MissingLayout {
            finalLayout = site.layout
        } else {
            finalLayout = layout
        }

        let values = EnvironmentValues(
            sourceDirectory: sourceDirectory,
            site: site,
            allContent: allContent,
            page: page)

        return withEnvironment(values) {
            finalLayout.body.render()
        }
    }

    /// Renders a static page.
    /// - Parameters:
    ///   - page: The page to render.
    ///   - isHomePage: True if this is your site's homepage; this affects the
    ///   final path that is written to.
    func render(_ staticLayout: any StaticLayout, isHomePage: Bool = false) {
        let path = isHomePage ? "" : staticLayout.path
        currentRenderingPath = isHomePage ? "/" : staticLayout.path

        let values = EnvironmentValues(sourceDirectory: sourceDirectory, site: site, allContent: allContent)
        let body = withEnvironment(values) {
            staticLayout.body
        }

        let page = Page(
            title: staticLayout.title,
            description: staticLayout.description,
            url: site.url.appending(path: path),
            image: staticLayout.image,
            body: body
        )

        let outputString = render(page, using: staticLayout.parentLayout)
        let outputDirectory = buildDirectory.appending(path: path)
        write(outputString, to: outputDirectory, priority: isHomePage ? 1 : 0.9)
    }

    /// Renders one piece of Markdown content.
    /// - Parameter content: The content to render.
    func render(_ content: Content) {
        let layout = layout(for: content)

        let values = EnvironmentValues(
            sourceDirectory: sourceDirectory,
            site: site,
            allContent: allContent,
            article: content)

        let body = withEnvironment(values) {
            Section(layout.body)
        }

        currentRenderingPath = content.path

        let page = Page(
            title: content.title,
            description: content.description,
            url: site.url.appending(path: content.path),
            image: content.image.flatMap { URL(string: $0) },
            body: body
        )

        let outputString = render(page, using: layout.parentLayout)
        let outputDirectory = buildDirectory.appending(path: content.path)
        write(outputString, to: outputDirectory, priority: 0.8)
    }

    /// Renders all tags pages, including the "all tags" page.
    func renderTagLayouts() async {
        if site.tagLayout is EmptyTagLayout { return }

        /// Creates a unique list of sorted tags from across the site, starting
        /// with `nil` for the "all tags" page.
        let tags: [String?] = [nil] + Set(allContent.flatMap(\.tags)).sorted()

        for tag in tags {
            let path: String

            if let tag {
                path = "tags/\(tag.convertedToSlug() ?? tag)"
            } else {
                path = "tags"
            }

            let outputDirectory = buildDirectory.appending(path: path)

            let values = EnvironmentValues(
                sourceDirectory: sourceDirectory,
                site: site,
                allContent: allContent,
                tag: tag,
                taggedContent: content(tagged: tag))

            let body = withEnvironment(values) {
                Section(site.tagLayout.body)
            }

            let page = Page(
                title: "Tags",
                description: "Tags",
                url: site.url.appending(path: path),
                body: body
            )

            let outputString = render(page, using: site.tagLayout.parentLayout)

            write(outputString, to: outputDirectory, priority: tag == nil ? 0.7 : 0.6)
        }
    }

    /// Locates the best layout to use for a piece of Markdown content. Layouts
    /// are specified using YAML front matter, but if none are found then the first
    /// layout in your site's `layouts` property is used.
    /// - Parameter content: The content that is being rendered.
    /// - Returns: The correct `ContentPage` instance to use for this content.
    func layout(for content: Content) -> any ContentLayout {
        if let contentLayout = content.layout {
            for layout in site.contentLayouts {
                let layoutName = String(describing: type(of: layout))

                if layoutName == contentLayout {
                    return layout
                }
            }

            fatalError(.missingNamedLayout(contentLayout))
        } else if let defaultLayout = site.contentLayouts.first {
            return defaultLayout
        } else {
            fatalError(.missingDefaultLayout)
        }
    }
}
