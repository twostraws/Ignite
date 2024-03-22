//
// FeedLink.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Displays a link to your RSS feed, if enabled.
struct FeedLink: Component {
    public init() { }

    func body(context: PublishingContext) -> [any PageElement] {
        if context.site.isFeedEnabled {
            Text {
                if context.site.builtInIconsEnabled {
                    Image(systemName: "rss-fill")
                        .foregroundStyle(Color(hex: "#f26522"))
                        .margin(.trailing, 10)
                }

                Link("RSS Feed", target: "/feed.rss")
            }
            .horizontalAlignment(.center)
        }
    }
}
