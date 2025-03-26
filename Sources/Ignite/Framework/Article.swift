//
// Content.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// One piece of Markdown content for this site.
///
/// - Important: If your content has code blocks containing angle brackets (`<`...`>`),
/// such as Swift generics, the prettifier will interpret these as HTML tags and break
/// the code's formatting. To avoid this issue, either set your site’s `shouldPrettify`
/// property to `false`, or replace `<` and `>` with their character entity references,
/// `&lt;` and `&gt;` respectively.
@MainActor
public struct Article {
    /// The main title for this content.
    public var title: String = ""

    /// A summary of this content.
    public var description: String = ""

    /// A relative path for this content.
    public var path: String = ""

    /// Extra metadata as extracted from YAML front matter.
    /// See https://jekyllrb.com/docs/front-matter/
    public var metadata: [String: any Sendable] = [:]

    /// The main text of this content. Excludes its title.
    public var text: String = ""

    /// Set to true when no specific date was found for this content,
    /// so one was provided by examining the filesystem date.
    public var hasAutomaticDate = false

    /// The publication date of this content.
    public var date: Date {
        metadata["date"] as? Date ?? .now
    }

    /// The last modified date of this content. This might be the same as
    /// the publication date if the content has not subsequently been changed.
    public var lastModified: Date {
        metadata["lastModified"] as? Date ?? date
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
    public var tags: [String]? {
        if let tags = metadata["tags"] as? String {
            return tags.splitAndTrim()
        }
        return nil
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
        text.matches(of: #/[\w-]+/#).count
    }

    /// A rough estimate of how many minutes it takes to read this content,
    /// using an approximate value of 250 words per minute.
    public var estimatedReadingMinutes: Int {
        Int(ceil(Double(estimatedWordCount) / 250))
    }

    /// Keys for resources required on initialization
    static nonisolated let resourceKeys: [URLResourceKey] = [.creationDateKey, .contentModificationDateKey]

    /// Creates a new `Content` instance by parsing a filesystem URL.
    /// - Parameters:
    ///   - url: The filesystem URL that contains Markdown to parse.
    ///   - baseURL: The base URL for this domain. Used to calculate the
    ///   relative path to this content.
    ///   - resourceValues: Resource values that provide the creation and
    ///   last modification date for this content.
    ///   - deployPath: optional String used as site url path for the content.
    ///   If nil (default), use `metadata["path"]` or path to content root.
    init(
        from url: URL,
        in context: PublishingContext,
        resourceValues: URLResourceValues,
        deployPath: String
    ) throws {
        var markdown: String

        do {
            markdown = try String(contentsOf: url)
        } catch {
            throw PublishingError.unopenableFile(error.localizedDescription)
        }

        let processed = processMetadata(for: markdown)

        // Use whatever Markdown renderer was configured
        // for the site we're publishing.
        let parser = try context.site.articleRenderer.init(markdown: processed, removeTitleFromBody: true)

        self.text = parser.body
        self.description = parser.description.strippingTags()

        resolveTitle(parser.title, url: url)
        populateMetadataDates(urlValues: resourceValues)

        self.path = metadata["path"] as? String ?? deployPath

        // Save the first subfolder in the path as the article's type
        let pathParts = path.split(separator: "/") // removes empty
        if pathParts.count > 1 { // no type if not in subdirectory
            metadata["type"] = pathParts[0]
        }
    }

    /// Determines the article title using metadata, parsed content, or the URL filename.
    /// Prioritizes title from metadata, falls back to parsed title, and uses filename as last resort.
    /// - Parameters:
    ///   - title: The title from the parsed content
    ///   - url: The URL of the source file, used as fallback for the title
    private mutating func resolveTitle(_ title: String, url: URL) {
        if let title = metadata["title"] as? String {
            self.title = title
        } else if title.isEmpty {
            // Assign a title that's better than the default empty string.
            self.title = url.deletingPathExtension().lastPathComponent
        } else {
            self.title = title.strippingTags()
        }
    }

    /// Looks for and parses any YAML front matter from this Markdown.
    /// - Parameter markdown: The Markdown string to process.
    /// - Returns: The remaining Markdown, once front matter has been removed.
    private mutating func processMetadata(for markdown: String) -> String {
        if markdown.starts(with: "---") {
            let parts = markdown.split(separator: "---", maxSplits: 1, omittingEmptySubsequences: true)

            let header = parts[0].split(separator: "\n", omittingEmptySubsequences: true)

            for entry in header {
                let entryParts = entry.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
                guard entryParts.count == 2 else { continue }

                let trimmedValue = entryParts[1].trimmingCharacters(in: .whitespaces)
                metadata[entryParts[0].trimmingCharacters(in: .whitespaces)] = trimmedValue
            }

            return String(parts[1].trimmingCharacters(in: .whitespacesAndNewlines))
        } else {
            return markdown
        }
    }

    /// Populates the article's metadata with publication and modification dates.
    /// Uses filesystem dates when metadata dates are unavailable or invalid.
    /// - Parameter urlValues: Resource values containing filesystem creation and modification dates
    private mutating func populateMetadataDates(urlValues: URLResourceValues) {
        if let date = parseMetadataDate(for: "date") {
            metadata["date"] = date
        } else {
            metadata["date"] = urlValues.creationDate ?? Date.now
            hasAutomaticDate = true
        }

        if let lastModified = parseMetadataDate(for: "modified", "lastModified") {
            metadata["lastModified"] = lastModified
        } else {
            metadata["lastModified"] = urlValues.contentModificationDate ?? Date.now
        }
    }

    /// Attempts to parse a date string in the format "y-M-d HH:mm" or "y-M-d".
    /// - Parameter date: The date string to parse
    /// - Returns: A `Date` if parsing succeeds, `nil` otherwise
    private func process(date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = .gmt

        let formats = ["y-M-d", "y-M-d HH:mm", "y-M-d H:m", "y-M-d HH:mm:ss", "y-M-d H:m:s"]
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: date) {
                return date
            }
        }

        return nil
    }

    /// Extracts and parses a date from metadata using specified identifiers.
    /// - Parameter ids: The metadata keys to check for date values
    /// - Returns: A parsed `Date` if found, `nil` otherwise
    /// - Throws: An error if date parsing fails
    private func parseMetadataDate(for ids: String...) -> Date? {
        for id in ids {
            guard let dateString = metadata[id] as? String else { continue }
            if let date = process(date: dateString) {
                return date
            } else {
                PublishingContext.shared.addError(.badContentDateFormat)
                continue
            }
        }

        return nil
    }

    /// Get the full URL to this content. Useful for creating feed XML that includes
    /// this content.
    public func path(in site: any Site) -> String {
        site.url.appending(path: path).absoluteString
    }

    /// The visual style for tag links.
    public enum TagLinkStyle: Hashable, CaseIterable, Sendable {
        /// Displays tags as badge components with primary role and margin.
        case automatic
        /// Displays tags as simple text links.
        case plain
    }

    /// Creates an array of links for the article's tags
    /// - Parameter style: The visual style to use for the tag links. Defaults to `.automatic`
    /// - Returns: An array of `Link` objects for each tag, or `nil` if the article has no tags
    public func tagLinks(style: TagLinkStyle = .automatic) -> [Link]? {
        guard let tags = metadata["tags"] as? String else { return nil }

        let targets: [(name: String, path: String)] = tags.splitAndTrim().map { tag in
            let tagPath = tag.convertedToSlug()
            return (name: tag, path: "/tags/\(tagPath)")
        }

        guard !targets.isEmpty else { return nil }

        return targets.map { target in
            if style == .automatic {
                Link(target: target.path) {
                    Badge(target.name)
                        .role(.primary)
                }
                .relationship(.tag)
            } else {
                Link(target.name, target: target.path)
                    .relationship(.tag)
            }
        }
    }
}

extension Article {
    static let empty = Article()

    /// Creates an empty markdown content instance with default values.
    init() {
        self.title = ""
        self.description = ""
        self.path = ""
        self.metadata = [:]
        self.text = ""
        self.hasAutomaticDate = false
    }
}
