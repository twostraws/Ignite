//
// SiteMapGenerator.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

struct SiteMapGenerator {
    var context: PublishingContext

    func generateSiteMap() -> String {
        let locations = context.siteMap.map {
            "<url><loc>\(context.site.url.absoluteString)\($0.path)</loc><priority>\($0.priority)</priority></url>"
        }.joined()

        return """
        <?xml version="1.0" encoding="UTF-8"?>\
        <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\
        \(locations)\
        </urlset>
        """
    }
}
