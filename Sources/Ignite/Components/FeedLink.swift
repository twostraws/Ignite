//
// FeedLink.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Displays links to your syndication feeds, if enabled.
/// Renders one link per configured feed format (RSS, Atom, JSON Feed).
public struct FeedLink: HTML {

    @Environment(\.builtInIconsEnabled) private var builtInIconsEnabled
    @Environment(\.feedConfiguration) private var feedConfig

    public var body: some HTML {
        if let feedConfig {
            let sortedFormats = feedConfig.formats.sorted { $0.rawValue < $1.rawValue }
            ForEach(sortedFormats) { format in
                Text {
                    if builtInIconsEnabled != .none {
                        Image(systemName: "rss-fill")
                            .foregroundStyle("#f26522")
                            .margin(.trailing, .px(10))
                    }

                    let path = feedConfig.paths[format]
                        ?? FeedConfiguration.defaultPaths[format]
                        ?? "/feed.\(format.rawValue)"
                    Link("\(format.displayName) Feed", target: path)
                    EmptyInlineElement()
                }
                .horizontalAlignment(.center)
            }
        }
    }
}
