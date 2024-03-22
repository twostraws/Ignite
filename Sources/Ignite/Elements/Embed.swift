//
// Embed.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Embeds a custom URL, such as YouTube or Vimeo.
public struct Embed: BlockElement, LazyLoadable {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

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
