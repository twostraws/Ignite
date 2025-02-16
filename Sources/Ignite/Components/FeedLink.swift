//
// FeedLink.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Displays a link to your RSS feed, if enabled.
public struct FeedLink: HTML {

    @Environment(\.builtInIconsEnabled) private var builtInIconsEnabled
    @Environment(\.feedConfiguration) private var feedConfig

    public var body: some HTML {
        if let feedConfig {
            Text {
                if builtInIconsEnabled != .none {
                    Image(systemName: "rss-fill")
                        .foregroundStyle("#f26522")
                        .margin(.trailing, .px(10))
                }

                Link("RSS Feed", target: feedConfig.path)
                EmptyHTML()
            }
            .horizontalAlignment(.center)
        }
    }
}
