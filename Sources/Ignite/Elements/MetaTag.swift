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
    /// Allows mobile browsers to scale this page appropriately for the device.
    public static let flexibleViewport = MetaTag(name: "viewport", content: "width=device-width, initial-scale=1")

    /// Marks this page as using UTF-8 content.
    public static let utf8 = MetaTag(characterSet: "utf-8")

    /// Marks this page as having been automatically generated by Ignite.
    public static let generator = MetaTag(name: "generator", content: Ignite.version)

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
    var name: String

    /// The content to use for this metadata.
    var content: String

    /// A character set string that describes this page's content.
    var charset: String

    /// Creates a new `MetaTag` instance from the name and content provided.
    /// - Parameters:
    ///   - name: The name for the metadata.
    ///   - content: The value for the metadata.
    public init(name: String, content: String) {
        self.type = "name"

        self.name = name
        self.content = content
        self.charset = ""
    }

    /// A convenience initializer for when you want a named piece of data with a
    /// URL as its content. Creates a new `MetaTag` instance from the name
    /// and URL provided.
    /// - Parameters:
    ///   - name: The name for the metadata.
    ///   - content: The URL value for the metadata.
    public init(name: String, content: URL) {
        self.init(name: name, content: content.absoluteString)
    }

    /// Creates a new `MetaTag` instance from the property and content provided.
    /// - Parameters:
    ///   - property: The property name for the metadata.
    ///   - content: The value for the metadata.
    public init(property: String, content: String) {
        self.type = "property"

        self.name = property
        self.content = content
        self.charset = ""
    }

    /// A convenience initializer for when you want a named property of data with a
    /// URL as its content. Creates a new `MetaTag` instance from the property
    /// and URL provided.
    /// - Parameters:
    ///   - property: The name for the metadata.
    ///   - content: The URL value for the metadata.
    public init(property: String, content: URL) {
        self.init(property: property, content: content.absoluteString)
    }

    /// Creates a new piece of metadata that sets a specific character set for
    /// the current page.
    public init(characterSet: String) {
        self.type = "characterSet"

        self.name = ""
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
    @ElementBuilder<MetaTag> public static func socialSharingTags(
        for page: Page,
        with configuration: SiteConfiguration
    ) -> [MetaTag] {
        MetaTag(property: "og:site_name", content: configuration.name)

        if let image = page.image {
            MetaTag(property: "og:image", content: image)
            MetaTag(property: "twitter:image", content: image)
        }

        MetaTag(property: "og:title", content: page.title)
        MetaTag(property: "twitter:title", content: page.title)

        if page.description.isEmpty == false {
            MetaTag(property: "og:description", content: page.title)
            MetaTag(name: "twitter:description", content: page.title)
        }

        MetaTag(property: "og:url", content: page.url)

        if let domain = configuration.url.removingWWW {
            MetaTag(name: "twitter:domain", content: domain)
        }

        MetaTag(name: "twitter:card", content: "summary_large_image")
        MetaTag(name: "twitter:dnt", content: "on")
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        var attributes = CoreAttributes()
        attributes.selfClosingTag = "meta"

        if charset.isEmpty {
            attributes.append(customAttributes:
                .init(name: type, value: name),
                .init(name: "content", value: content)
            )
        } else {
            attributes.append(customAttributes:
                .init(name: "charset", value: charset)
            )
        }
        return attributes.description()
    }
}

extension MetaTag {
    /// The type of HTML this element returns after attributes have been applied.
    public typealias AttributedHTML = Self

    public func id(_ id: String) -> Self {
        attributes.id(id, persistentID: self.id)
        return self
    }

    @discardableResult public func `class`(_ classes: String...) -> Self {
        attributes.classes(classes, persistentID: id)
        return self
    }

    public func aria(_ key: AriaType, _ value: String) -> Self {
        attributes.aria(key, value, persistentID: id)
        return self
    }

    public func data(_ name: String, _ value: String) -> Self {
        attributes.data(name, value, persistentID: id)
        return self
    }

    public func style(_ property: Property, _ value: String) -> Self {
        attributes.style(property, value, persistentID: id)
        return self
    }
}
