//
// Content.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// One piece of Markdown content for this site.
@MainActor
public struct Content: Sendable {
    /// The main title for this content.
    public var title: String

    /// A summary of this content.
    public var description: String

    /// A relative path for this content.
    public var path: String

    /// Extra metadata as extracted from YAML front matter.
    /// See https://jekyllrb.com/docs/front-matter/
    public var metadata: [String: any Sendable]

    /// The main body of this content. Excludes its title.
    public var body: String

    /// Set to true when no specific date was found for this content,
    /// so one was provided by examining the filesystem date.
    public var hasAutomaticDate = false

    /// True if this content has tags attached to it.
    public var hasTags: Bool {
        tags.isEmpty == false
    }

    /// The publication date of this content.
    public var date: Date {
        metadata["date"] as? Date ?? .now
    }

    /// The last modified date of this content. This might be the same as
    /// the publication date if the content has not subsequently been changed.
    public var lastModified: Date {
        metadata["modified"] as? Date ?? date
    }

    /// The `ContentLayout` name to use for this content. This should be the name
    /// of a type that conforms to the `ContentLayout` protocol.
    public var layout: String? {
        metadata["layout"] as? String
    }

    /// The type of this content. This is automatically provided by Ignite based
    /// on the first subdirectory of your Markdown file. For example, a file placed
    /// in Content/stories will have the type "stories".
    public var type: String {
        if let type = metadata["type"] {
            type as? String ?? ""
        } else {
            fatalError("""
            Unable to retrieve type for article '\(title)'. \
            Please file a bug report on the Ignite project.
            """)
        }
    }

    /// An array of the tags used to describe this content.
    public var tags: [String] {
        if let tags = metadata["tags"] as? String {
            tags.splitAndTrim()
        } else {
            []
        }
    }

    /// The author for this content, if set.
    public var author: String? {
        metadata["author"] as? String
    }

    /// The subtitle for this content, if set.
    public var subtitle: String? {
        metadata["subtitle"] as? String
    }

    /// The image for this content, if set. This should be specified relative to
    /// the root of your site, e.g. /images/dog.jpg.
    public var image: String? {
        metadata["image"] as? String
    }

    /// An accessibility description for the image.
    public var imageDescription: String {
        metadata["alt"] as? String
        ?? ""
    }

    /// Whether this content should be published on the site or not. Defaults to true.
    public var isPublished: Bool {
        if let published = metadata["published"] as? String {
            Bool(published) ?? true
        } else {
            true
        }
    }

    /// A rough estimate of the number of words in this content.
    public var estimatedWordCount: Int {
        body.matches(of: #/[\w-]+/#).count
    }

    /// A rough estimate of how many minutes it takes to read this content,
    /// using an approximate value of 250 words per minute.
    public var estimatedReadingMinutes: Int {
        Int(ceil(Double(estimatedWordCount) / 250))
    }

    /// Creates a new `Content` instance by parsing a filesystem URL.
    /// - Parameters:
    ///   - url: The filesystem URL that contains Markdown to parse.
    ///   - baseURL: The base URL for this domain. Used to calculate the
    ///   relative path to this content.
    ///   - resourceValues: Resource values that provide the creation and
    ///   last modification date for this content.
    init(
        from url: URL,
        in context: PublishingContext,
        resourceValues: URLResourceValues
    ) throws {
        // Use whatever Markdown renderer was configured
        // for the site we're publishing.
        let parser = try context.site.markdownRenderer.init(url: url, removeTitleFromBody: true)

        body = parser.body
        metadata = parser.metadata
        title = parser.title.strippingTags()
        description = parser.description.strippingTags()

        if let customPath = metadata["path"] as? String {
            path = customPath
        } else {
            let basePath = context.contentDirectory.path()
            let thisPath = url.deletingPathExtension().path()
            path = String(thisPath.trimmingPrefix(basePath))
        }

        // Save the article's type as being the first subfolder
        // of this article inside the Content folder.
        let distinctComponents = url.pathComponents.dropFirst(context.contentDirectory.pathComponents.count)

        if let firstSubdirectory = distinctComponents.first {
            metadata["type"] = firstSubdirectory
        }

        if let date = metadata["date"] as? String {
            // The user attempted to set a date. This will
            // be stored as a string right now, so we need
            // to extract it, verify it, and put it back as
            // a date.
            metadata["date"] = process(date: date)

            // If the date is now nil, their format was bad and
            // needs to be fixed.
            if metadata["date"] == nil {
                fatalError("Content dates should be provided in the format 2024-05-24 15:30.")
            }
        }

        if let lastModified = metadata["modified"] as? String {
            // Same for last modified date.
            metadata["modified"] = process(date: lastModified)

            // If last modified is now nil, their format was bad and
            // needs to be fixed.
            if metadata["modified"] == nil {
                fatalError("Content dates should be provided in the format 2024-05-24 15:30.")
            }
        }

        if metadata["date"] == nil {
            metadata["date"] = resourceValues.creationDate ?? Date.now
            hasAutomaticDate = true
        }

        if metadata["modified"] == nil {
            metadata["modified"] = resourceValues.contentModificationDate ?? Date.now
        }
    }

    /// Get the full URL to this content. Useful for creating feed XML that includes
    /// this content.
    public func path(in site: any Site) -> String {
        site.url.appending(path: self.path).absoluteString
    }

    /// An array of `Link` objects that show badges for the tags of this
    /// content, and also link to the tag pages.
    public func tagLinks() -> [Link] {
        if let tags = metadata["tags"] as? String {
            tags.splitAndTrim().map { tag in
                let tagPath = tag.convertedToSlug() ?? tag

                return Link(target: "/tags/\(tagPath)") {
                    Badge(tag)
                        .role(.primary)
                        .margin(.trailing, .px(5))
                }
                .relationship(.tag)
            }
        } else {
            []
        }
    }

    // Converts a potentially sketchy date string into
    // a better `Date` instance.
    func process(date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd HH:mm"
        formatter.timeZone = .gmt
        return formatter.date(from: date)
    }
}

extension Content {
    static let empty = Content()

    /// Creates an empty markdown content instance with default values.
    init() {
        self.title = ""
        self.description = ""
        self.path = ""
        self.metadata = [:]
        self.body = ""
        self.hasAutomaticDate = false
    }
}
