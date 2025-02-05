//
// MetaTag.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// An item of metadata that helps browsers and search engines understand
/// your page better.
public struct MetaTag: HeadElement, Sendable {
    /// Metadata names for social media cards.
    public enum `Type`: String, Sendable {
        /// The image to display in Twitter cards.
        case twitterImage = "twitter:image"
        /// The title to display in Twitter cards.
        case twitterTitle = "twitter:title"
        /// The domain to display in Twitter cards.
        case twitterDomain = "twitter:domain"
        /// The type of Twitter card to use.
        case twitterCard = "twitter:card"
        /// Whether to disable Twitter tracking.
        case twitterDoNotTrack = "twitter:dnt"
        /// The description to display in Twitter cards.
        case twitterDescription = "twitter:description"
        /// The software used to generate the document.
        case generator
        /// The viewport configuration for responsive web design.
        case viewport

        /// The title of the shared content.
        case openGraphTitle = "og:title"
        /// A description of the shared content.
        case openGraphDescription = "og:description"
        /// The image to display when sharing.
        case openGraphImage = "og:image"
        /// The canonical URL of the shared content.
        case openGraphURL = "og:url"
        /// The name of the website.
        case openGraphSiteName = "og:site_name"

        /// The meta attribute key.
        var key: String {
            switch self {
            case .twitterImage, .twitterTitle, .twitterDomain, .twitterCard,
                 .twitterDoNotTrack, .twitterDescription, .generator, .viewport:
                "name"
            case .openGraphTitle, .openGraphDescription, .openGraphImage,
                 .openGraphURL, .openGraphSiteName:
                "property"
            }
        }
    }

    /// Allows mobile browsers to scale this page appropriately for the device.
    public static let flexibleViewport = MetaTag(.viewport, content: "width=device-width, initial-scale=1")

    /// Marks this page as using UTF-8 content.
    public static let utf8 = MetaTag(characterSet: "utf-8")

    /// Marks this page as having been automatically generated by Ignite.
    public static let generator = MetaTag(.generator, content: Ignite.version)

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The type of metadata being provided, which can either be "name"
    /// or "property".
    private var type: String

    /// The value to be placed into the "name" attribute.
    var value: String

    /// The content to use for this metadata.
    var content: String

    /// A character set string that describes this page's content.
    var charset: String

    /// A convenience initializer for when you want a piece of data with a
    /// URL as its content. Creates a new `MetaTag` instance from the type
    /// and URL provided.
    /// - Parameters:
    ///   - type: The type of metadata.
    ///   - content: The URL value for the metadata.
    public init(_ type: `Type`, content: URL) {
        self.init(type, content: content.absoluteString)
    }

    /// Creates a new `MetaTag` instance from a metadata type and content provided.
    /// - Parameters:
    ///   - type: The type of metadata.
    ///   - content: The value for the metadata.
    public init(_ type: `Type`, content: String) {
        self.type = type.key

        self.value = type.rawValue
        self.content = content
        self.charset = ""
    }

    /// Creates a new `MetaTag` instance from the custom name and content provided.
    /// - Parameters:
    ///   - name: The name for the metadata.
    ///   - content: The value for the metadata.
    public init(name: String, content: String) {
        self.type = "name"

        self.value = name
        self.content = content
        self.charset = ""
    }

    /// Creates a new `MetaTag` instance from the custom property and content provided.
    /// - Parameters:
    ///   - property: The property name for the metadata.
    ///   - content: The value for the metadata.
    public init(property: String, content: String) {
        self.type = "property"

        self.value = property
        self.content = content
        self.charset = ""
    }

    /// Creates a new piece of metadata that sets a specific character set for
    /// the current page.
    public init(characterSet: String) {
        self.type = "characterSet"

        self.value = ""
        self.content = ""
        self.charset = characterSet
    }

    /// Returns a standard set of social sharing metadata for a given page,
    /// including the page title, description, and image.
    /// - Parameters:
    ///   - page: The page for which metadata should be rendered.
    ///   - configuration: The site configuration.
    /// - Returns: An array of `MetaTag` objects that should be placed
    /// into your page header to enable social sharing.
    @ElementBuilder<MetaTag> public static func socialSharingTags(for page: Page) -> [MetaTag] {
        let site = PublishingContext.default.site
        MetaTag(.openGraphSiteName, content: site.name)

        if let image = page.image {
            MetaTag(.openGraphImage, content: image)
            MetaTag(.twitterImage, content: image)
        }

        MetaTag(.openGraphTitle, content: page.title)
        MetaTag(.twitterTitle, content: page.title)

        if page.description.isEmpty == false {
            MetaTag(.openGraphDescription, content: page.description)
            MetaTag(.twitterDescription, content: page.description)
        }

        MetaTag(.openGraphURL, content: page.url)

        if let domain = page.url.removingWWW {
            MetaTag(.twitterDomain, content: domain)
        }

        MetaTag(.twitterCard, content: "summary_large_image")
        MetaTag(.twitterDoNotTrack, content: "on")
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        var attributes = CoreAttributes()
        attributes.selfClosingTag = "meta"

        if charset.isEmpty {
            attributes.append(customAttributes:
                .init(name: type, value: value),
                .init(name: "content", value: content))
        } else {
            attributes.append(customAttributes:
                .init(name: "charset", value: charset)
            )
        }
        return attributes.description()
    }
}

public extension MetaTag {
    /// The type of HTML this element returns after attributes have been applied.
    typealias AttributedHTML = Self

    func id(_ id: String) -> Self {
        attributes.id(id, persistentID: self.id)
        return self
    }

    @discardableResult func `class`(_ classes: String...) -> Self {
        attributes.classes(classes, persistentID: id)
        return self
    }

    func aria(_ key: AriaType, _ value: String) -> Self {
        attributes.aria(key, value, persistentID: id)
        return self
    }

    func data(_ name: String, _ value: String) -> Self {
        attributes.data(name, value, persistentID: id)
        return self
    }

    @discardableResult func style(_ property: Property, _ value: String) -> Self {
        attributes.style(property, value, persistentID: id)
        return self
    }
}
