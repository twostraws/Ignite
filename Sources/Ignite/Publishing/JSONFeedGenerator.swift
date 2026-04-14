//
// JSONFeedGenerator.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Represents a JSON Feed v1.1 document.
private struct JSONFeed: Encodable {
    var version: String
    var title: String
    var home_page_url: String
    var feed_url: String
    var description: String?
    var language: String
    var icon: String?
    var authors: [JSONFeedAuthor]?
    var items: [JSONFeedItem]
}

/// Represents an author in a JSON Feed.
private struct JSONFeedAuthor: Encodable {
    var name: String
}

/// Represents an item in a JSON Feed.
private struct JSONFeedItem: Encodable {
    var id: String
    var url: String
    var title: String
    var summary: String
    var content_html: String?
    var date_published: String
    var authors: [JSONFeedAuthor]?
    var tags: [String]?
}

/// Generates a JSON Feed v1.1 document from site content.
@MainActor
struct JSONFeedGenerator {
    var feedConfig: FeedConfiguration
    var site: any Site
    var content: [Article]

    init(config: FeedConfiguration, site: any Site, content: [Article]) {
        self.feedConfig = config
        self.site = site
        self.content = content
    }

    func generateFeed() -> String {
        let feedItems = content.prefix(feedConfig.contentCount).map { item -> JSONFeedItem in
            let absoluteURL = item.path(in: site)
            let authorName = item.author ?? (site.author.isEmpty ? nil : site.author)

            var feedItem = JSONFeedItem(
                id: absoluteURL,
                url: absoluteURL,
                title: item.title,
                summary: item.description,
                date_published: item.date.asRFC3339(timeZone: site.timeZone)
            )

            if feedConfig.mode == .full {
                feedItem.content_html = item.text.makingAbsoluteLinks(relativeTo: site.url)
            }

            if let authorName, !authorName.isEmpty {
                feedItem.authors = [JSONFeedAuthor(name: authorName)]
            }

            if let tags = item.tags, !tags.isEmpty {
                feedItem.tags = tags
            }

            return feedItem
        }

        let siteAuthor = site.author.isEmpty ? nil : site.author

        let feed = JSONFeed(
            version: "https://jsonfeed.org/version/1.1",
            title: site.name,
            home_page_url: site.url.absoluteString,
            feed_url: site.url.appending(path: feedConfig.paths[.json] ?? "/feed.json").absoluteString,
            description: site.description,
            language: site.language.rawValue,
            icon: feedConfig.image?.url,
            authors: siteAuthor.map { [JSONFeedAuthor(name: $0)] },
            items: Array(feedItems)
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted, .withoutEscapingSlashes]

        guard let data = try? encoder.encode(feed),
              let jsonString = String(data: data, encoding: .utf8) else {
            return "{}"
        }

        return jsonString
    }
}
