//
// Embed.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Embeds a custom URL, such as YouTube or Vimeo.
public struct Embed: BlockHTML, LazyLoadable {
    /// Determines what kind of Spotify embed we have.
    public enum SpotifyContentType: String {
        /// Creates interactive item for a single Spotify track
        case track
        /// Creates interactive  item for a Spotify playlist
        case playlist
        /// Create interactive item for a Spotify artist
        case artist
        /// Creates interactive item for a Spotify album
        case album
        /// Creates interactive item for a Spotify podcast
        case show
        /// Creates interactive item for a Spotify episode
        case episode
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// The URL we're embedding inside our page.
    let url: String

    /// A title that describes this content.
    let title: String

    /// Creates a new `Embed` instance from the titl and URL provided.
    /// - Parameters:
    ///   - title: A title suitable for screenreaders.
    ///   - url: The URL to embed on your page.
    public init(title: String, url: URL) {
        self.url = url.absoluteString
        self.title = title
    }

    /// Creates a new `Embed` instance from the title and URL provided.
    /// - Parameters:
    ///   - title: A title suitable for screen readers.
    ///   - url: The URL to embed on your page.
    public init(title: String, url: String) {
        self.url = url
        self.title = title
    }

    /// Creates a new `Embed` instance from the title and Vimeo ID provided.
    /// - Parameters:
    ///   - title: A title suitable for screen readers.
    ///   - url: The Vimeo ID to use.
    public init(vimeoID: Int, title: String) {
        if let test = URL(string: "https://player.vimeo.com/video/\(vimeoID)") {
            self.url = test.absoluteString
            self.title = String(title)
        } else {
            fatalError("Failed to create Vimeo URL from video ID: \(vimeoID).")
        }
    }

    /// Creates a new `Embed` instance from the title and YouTube ID provided.
    /// - Parameters:
    ///   - title: A title suitable for screen readers.
    ///   - url: The YouTube ID to use.
    public init(youTubeID: String, title: String) {
        if let test = URL(string: "https://www.youtube-nocookie.com/embed/\(youTubeID)") {
            self.url = test.absoluteString
            self.title = title
        } else {
            fatalError("Failed to create YouTube URL from video ID: \(youTubeID).")
        }
    }

    /// Creates a new `Embed` instance from the title and Spotify ID provided.
    /// - Parameters:
    ///   - title: A title suitable for screen readers.
    ///   - url: The Spotify ID to use.
    ///   - type: The SpotifyContentType to use.
    ///   - theme: Either 0 or 1, each representing one of the two theme
    ///   options offered by Spotify, which can be found in the code they provide.
    public init(spotifyID: String, title: String, type: SpotifyContentType = .track, theme: Int = 0) {
        if let test = URL(
            string: "https://open.spotify.com/embed/\(type.rawValue)/\(spotifyID)?utm_source=generator&theme=\(theme)"
        ) {
            self.url = test.absoluteString
            self.title = title
        } else {
            fatalError("Failed to create Spotify URL from ID: \(spotifyID).")
        }
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        // Enough permissions for users to accomplish common
        // tasks safely.
        let allowPermissions = """
            accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share
            """

        if attributes.classes.contains("ratio") == false {
            context.addWarning("""
            Embedding \(url) without an aspect ratio will cause it to appear very small. \
            It is recommended to use aspectRatio() so it can scale automatically.
            """)
        }

        return Group {
             #"<iframe src="\#(url)" title="\#(title)" allow="\#(allowPermissions)"></iframe>"#
        }
        .attributes(attributes)
        .render(context: context)
    }
}
