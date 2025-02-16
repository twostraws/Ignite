//
// FeedConfiguration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Configures feed generation for a site.
public struct FeedConfiguration: Sendable {
    /// How much content should be provided in this feed.
    public enum ContentMode: Sendable {
        /// Provide only the description of each piece of content.
        case descriptionOnly

        /// Provide the full article content in the feed.
        case full
    }

    /// Configures an image to be used with your feed, to customize its
    /// appearance in feed readers.
    public struct FeedImage: Sendable {
        /// The URL to your feed image.
        var url: String

        /// The width of the feed image. Must be 144 points or lower.
        var width: Int

        /// The height of the feed image. Must be 400 points of lower.
        var height: Int

        /// Creates a new `FeedImage` from the configuration options provided.
        /// - Parameters:
        ///   - url: The URL to your feed image.
        ///   - width: The width of the feed image. Must be 144 points or lower.
        ///   - height: The height of the feed image. Must be 400 points of lower.
        public init(url: String, width: Int, height: Int) {
            if width > 144 || height > 400 {
                fatalError("FeedConfiguration images must be no greater than 144 pixels wide by 400 pixels high.")
            }

            self.url = url
            self.width = width
            self.height = height
        }
    }

    /// How much content should be provided in this feed.
    var mode: ContentMode

    /// How many items of content should be returned.
    var contentCount: Int

    /// The path to where the generated rss xml file for the feed endpoint should be.
    var path: String

    /// An optional image used to customize your feed's appearance in
    /// feed readers.
    var image: FeedImage?

    /// A safe default feed configuration: 20 items, description only, path at /feed.rss.
    static let `default` = FeedConfiguration(mode: .descriptionOnly, contentCount: 20, path: "/feed.rss")

    /// Creates a custom feed configuration from the options provided.
    /// - Parameters:
    ///   - mode: Whether to descriptions or full article text.
    ///   - contentCount: How many pieces of content to return.
    ///   Initializer returns `nil` if less than or equal to `0`.
    ///   - path: The path where the RSS feed should be accessible, default to /feed.rss
    ///   - image: An optional image used to customize your feed's
    ///   appearance in feed readers.
    public init?(mode: ContentMode, contentCount: Int, path: String = "/feed.rss", image: FeedImage? = nil) {
        guard contentCount > 0 else { return nil }
        self.mode = mode
        self.contentCount = contentCount
        self.path = path
        self.image = image
    }
}
