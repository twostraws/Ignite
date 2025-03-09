//
// FeedGenerator.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
struct FeedGenerator {
    var feedConfig: FeedConfiguration
    var site: any Site
    var content: [Article]

    init(config: FeedConfiguration, site: any Site, content: [Article]) {
        self.feedConfig = config
        self.site = site
        self.content = content
    }

    func generateFeed() -> String {
        let contentXML = generateContentXML()
        var result = generateRSSHeader()

        if let image = feedConfig.image {
            result += """
            <image>\
            <url>\(image.url)</url>\
            <title>\(site.name)</title>\
            <link>\(site.url.absoluteString)</link>\
            <width>\(image.width)</width>\
            <height>\(image.height)</height>\
            </image>
            """
        }

        result += """
        \(contentXML)\
        </channel>\
        </rss>
        """

        return result
    }

    private func generateContentXML() -> String {
        content
            .prefix(feedConfig.contentCount)
            .map { item in
                var itemXML = """
                <item>\
                <guid isPermaLink="true">\(item.path(in: site))</guid>\
                <title>\(item.title)</title>\
                <link>\(item.path(in: site))</link>\
                <description><![CDATA[\(item.description)]]></description>\
                <pubDate>\(item.date.asRFC822(timeZone: site.timeZone))</pubDate>
                """

                let authorName = item.author ?? site.author

                if site.author.isEmpty == false {
                    itemXML += "<dc:creator><![CDATA[\(authorName)]]></dc:creator>"
                }

                item.tags?.forEach { tag in
                    itemXML += "<category><![CDATA[\(tag)]]></category>"
                }

                if feedConfig.mode == .full {
                    itemXML += """
                    <content:encoded>\
                    <![CDATA[\(item.text.makingAbsoluteLinks(relativeTo: site.url))]]>\
                    </content:encoded>
                    """
                }

                itemXML += "</item>"
                return itemXML
            }.joined()
    }

    private func generateRSSHeader() -> String {
        """
        <?xml version="1.0" encoding="UTF-8" ?>\
        <rss version="2.0" \
        xmlns:dc="http://purl.org/dc/elements/1.1/" \
        xmlns:atom="http://www.w3.org/2005/Atom" \
        xmlns:content="http://purl.org/rss/1.0/modules/content/">\
        <channel>\
        <title>\(site.name)</title>\
        <description>\(site.description ?? "")</description>\
        <link>\(site.url.absoluteString)</link>\
        <atom:link
            href="\(site.url.appending(path: feedConfig.path).absoluteString)"
            rel="self" type="application/rss+xml"
        />\
        <language>\(site.language.rawValue)</language>\
        <generator>\(Ignite.version)</generator>
        """
    }
}
