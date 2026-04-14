//
// FeedConfiguration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The syndication formats Ignite can generate.
public enum FeedFormat: String, Sendable, CaseIterable, Hashable {
    /// RSS 2.0 (XML).
    case rss

    /// Atom (RFC 4287, XML).
    case atom

    /// JSON Feed v1.1.
    case json

    /// A human-readable display name for this format.
    public var displayName: String {
        switch self {
        case .rss: "RSS"
        case .atom: "Atom"
        case .json: "JSON Feed"
        }
    }

    /// The MIME content type for this feed format.
    public var contentType: String {
        switch self {
        case .rss: "application/rss+xml"
        case .atom: "application/atom+xml"
        case .json: "application/feed+json"
        }
    }
}

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

    /// Which feed formats to generate. Defaults to `[.rss]` for backward
    /// compatibility with existing sites.
    public var formats: Set<FeedFormat>

    /// Per-format output paths. Each enabled format gets a path where its
    /// feed file will be written during publishing.
    public var paths: [FeedFormat: String]

    /// An optional image used to customize your feed's appearance in
    /// feed readers.
    var image: FeedImage?

    /// An optional list of content types to include in the feed.
    /// When nil, all content types are included.
    var contentTypes: [String]?

    /// Default output paths for each feed format.
    public static let defaultPaths: [FeedFormat: String] = [
        .rss: "/feed.rss",
        .atom: "/feed.atom",
        .json: "/feed.json"
    ]

    /// The RSS feed path. Shorthand for `paths[.rss]`.
    ///
    /// This property exists for backward compatibility with code that
    /// was written before multi-format feed support was added.
    public var path: String {
        get { paths[.rss] ?? Self.defaultPaths[.rss] ?? "/feed.rss" }
        set { paths[.rss] = newValue }
    }

    /// A safe default feed configuration: 20 items, description only,
    /// RSS format at /feed.rss.
    static let `default` = FeedConfiguration(
        mode: .descriptionOnly,
        contentCount: 20,
        path: "/feed.rss"
    )

    /// Creates a custom feed configuration from the options provided.
    /// - Parameters:
    ///   - mode: Whether to use descriptions or full article text.
    ///   - contentCount: How many pieces of content to return.
    ///     Initializer returns `nil` if less than or equal to `0`.
    ///   - path: The path where the RSS feed should be accessible,
    ///     defaults to /feed.rss.
    ///   - image: An optional image used to customize your feed's
    ///     appearance in feed readers.
    ///   - contentTypes: An optional list of content types to include
    ///     (e.g. `["letters"]`). When nil, all types are included.
    ///   - formats: Which feed formats to generate. Defaults to
    ///     `[.rss]` for backward compatibility.
    ///   - paths: Per-format output paths. Defaults are provided for
    ///     each format. The `path` parameter sets the RSS path.
    public init?(
        mode: ContentMode,
        contentCount: Int,
        path: String = "/feed.rss",
        image: FeedImage? = nil,
        contentTypes: [String]? = nil,
        formats: Set<FeedFormat> = [.rss],
        paths: [FeedFormat: String]? = nil
    ) {
        guard contentCount > 0 else { return nil }
        self.mode = mode
        self.contentCount = contentCount
        self.image = image
        self.contentTypes = contentTypes
        self.formats = formats

        // Merge explicit paths over defaults; the `path` parameter seeds
        // the RSS entry for backward compatibility.
        var resolved = Self.defaultPaths
        if let paths {
            resolved.merge(paths) { _, new in new }
        }
        resolved[.rss] = path
        self.paths = resolved
    }
}
