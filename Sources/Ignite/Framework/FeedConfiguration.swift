//
// FeedConfiguration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Configures feed generation for a site.
public struct FeedConfiguration {
    /// How much content should be provided in this feed.
    public enum ContentMode {
        /// Disable the feed entirely.
        case disabled

        /// Provide only the description of each piece of content.
        case descriptionOnly

        /// Provide the full article content in the feed.
        case full
    }

    /// Configures an image to be used with your feed, to customize its
    /// appearance in feed readers.
    public struct FeedImage {
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

    /// How many items of contentshould be returned.
    var contentCount: Int

    /// An optional image used to customize your feed's appearance in
    /// feed readers.
    var image: FeedImage?

    /// A safe default feed configuration: 20 items, description only.
    static let `default` = FeedConfiguration(mode: .descriptionOnly, contentCount: 20)

    /// Creates a custom feed configuration from the options provided.
    /// - Parameters:
    ///   - mode: Whether to descriptions or full article text, or to disable the
    ///   feed entirely.
    ///   - contentCount: How many pieces of content to return.
    ///   - image: An optional image used to customize your feed's
    ///   appearance in feed readers.
    public init(mode: ContentMode, contentCount: Int, image: FeedImage? = nil) {
        self.mode = mode
        self.contentCount = contentCount
        self.image = image
    }
}
