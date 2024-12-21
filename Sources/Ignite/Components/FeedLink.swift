//
// FeedLink.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Displays a link to your RSS feed, if enabled.
public struct FeedLink: HTML {

    @Environment(\.siteConfiguration) private var siteConfig
    @Environment(\.feedConfiguration) private var feedConfig

    public var body: some HTML {
        Text {
            if siteConfig.builtInIconsEnabled != .none {
                Image(systemName: "rss-fill")
                    .foregroundStyle("#f26522")
                    .margin(.trailing, 10)
            }

            Link("RSS Feed", target: feedConfig.path)
            EmptyHTML()
        }
        .horizontalAlignment(.center)
    }
}
