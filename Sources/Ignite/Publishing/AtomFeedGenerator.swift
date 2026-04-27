//
// AtomFeedGenerator.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Generates an Atom XML feed (RFC 4287) from site content.
@MainActor
struct AtomFeedGenerator {
    /// The feed configuration controlling output mode, content count, and image.
    var feedConfig: FeedConfiguration

    /// The site whose metadata populates the feed header.
    var site: any Site

    /// The articles to include as feed entries, expected in pre-sorted order.
    var content: [Article]

    /// Creates a new Atom feed generator.
    /// - Parameters:
    ///   - config: The feed configuration to use.
    ///   - site: The site whose metadata populates the feed header.
    ///   - content: The articles to include as feed entries.
    init(config: FeedConfiguration, site: any Site, content: [Article]) {
        self.feedConfig = config
        self.site = site
        self.content = content
    }

    /// Generates the complete Atom XML feed as a string.
    /// - Returns: A valid Atom XML document.
    func generateFeed() -> String {
        let entries = generateEntries()
        var result = generateHeader()
        result += entries
        result += "</feed>"
        return result
    }

    /// Generates the Atom feed header including metadata elements.
    private func generateHeader() -> String {
        let feedPath = feedConfig.paths[.atom] ?? "/feed.atom"
        let selfURL = site.url.appending(path: feedPath).absoluteString

        var header = """
        <?xml version="1.0" encoding="UTF-8"?>\
        <feed xmlns="http://www.w3.org/2005/Atom">\
        <title>\(site.name.escapedForXML())</title>
        """

        if let description = site.description, description.isEmpty == false {
            header += "<subtitle>\(description.escapedForXML())</subtitle>"
        }

        header += """
        <link href="\(site.url.absoluteString)" rel="alternate"/>\
        <link href="\(selfURL)" rel="self" type="application/atom+xml"/>\
        <id>\(site.url.absoluteString)/</id>
        """

        let mostRecentDate = content.first?.date ?? Date.now
        header += "<updated>\(mostRecentDate.asISO8601(timeZone: site.timeZone))</updated>"

        if site.author.isEmpty == false {
            header += "<author><name>\(site.author.escapedForXML())</name></author>"
        }

        header += """
        <generator uri="https://github.com/twostraws/Ignite" \
        version="\(Ignite.version)">Ignite</generator>
        """

        if let image = feedConfig.image {
            header += "<icon>\(image.url)</icon>"
            header += "<logo>\(image.url)</logo>"
        }

        return header
    }

    /// Generates XML for all feed entries.
    private func generateEntries() -> String {
        content
            .prefix(feedConfig.contentCount)
            .map { item in
                var entryXML = """
                <entry>\
                <title>\(item.title.escapedForXML())</title>\
                <link href="\(item.path(in: site))" rel="alternate"/>\
                <id>\(item.path(in: site))</id>\
                <updated>\(item.date.asISO8601(timeZone: site.timeZone))</updated>\
                <published>\(item.date.asISO8601(timeZone: site.timeZone))</published>
                """

                let authorName = item.author ?? site.author
                if authorName.isEmpty == false {
                    entryXML += "<author><name>\(authorName.escapedForXML())</name></author>"
                }

                entryXML += "<summary type=\"html\"><![CDATA[\(item.description)]]></summary>"

                if feedConfig.mode == .full {
                    entryXML += """
                    <content type="html">\
                    <![CDATA[\(item.text.makingAbsoluteLinks(relativeTo: site.url))]]>\
                    </content>
                    """
                }

                item.tags?.forEach { tag in
                    entryXML += "<category term=\"\(tag.escapedForXML())\"/>"
                }

                entryXML += "</entry>"
                return entryXML
            }.joined()
    }
}
