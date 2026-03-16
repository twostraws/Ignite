//
// SiteMapGenerator.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
struct SiteMapGenerator {
    var context: PublishingContext

    func generateSiteMap() -> String {
        let locations = context.siteMap.map {
            let path = $0.path.hasSuffix("/") ? $0.path : $0.path + "/"
            return "<url><loc>\(context.site.url.absoluteString)\(path)</loc><priority>\($0.priority)</priority></url>"
        }.joined()

        return """
        <?xml version="1.0" encoding="UTF-8"?>\
        <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\
        \(locations)\
        </urlset>
        """
    }
}
