//
// MetaLink.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// An item of metadata that links to an external resource somehow, such as
/// a stylesheet.
public struct MetaLink: HeadElement, Sendable {
    /// The standard CSS you should include on all Ignite pages.
    public static let standardCSS = MetaLink(href: "/css/bootstrap.min.css", rel: .stylesheet)

    /// The standard CSS you should include on all Ignite pages if using remote Bootstrap files
    public static var standardRemoteCSS: some HeadElement {
        MetaLink(
            href: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css",
            rel: .stylesheet)
        .customAttribute(
            name: "integrity",
            value: "sha384-SgOJa3DmI69IUzQ2PVdRZhwQ+dy64/BUtbMJw1MZ8t5HZApcHrRKUc4W0kG879m7")
        .customAttribute(name: "crossorigin", value: "anonymous")
    }

    /// The CSS you should include for Ignite pages that use system icons.
    public static let iconCSS = MetaLink(href: "/css/bootstrap-icons.min.css", rel: .stylesheet)

    /// The CSS you should include for Ignite pages that use system icons if using Bootstrap from a CDN.
    public static let remoteIconCSS = MetaLink(
        href: "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css",
        rel: .stylesheet)

    /// The CSS responsible for applying CSS relating to animations and themes..
    static let igniteCoreCSS = MetaLink(href: "/css/ignite-core.min.css", rel: .stylesheet)

    /// The CSS used in Prism plugins like line numbering and line highlighting.
    static let prismPluginCSS = MetaLink(href: "/css/prism-plugins.css", rel: .stylesheet)

    /// Creates an array of `MetaLink` elements for syntax highlighting themes.
    /// - Parameter themes: A collection of syntax highlighting themes to include.
    /// - Returns: An array of MetaLink elements. If multiple themes are provided,
    /// includes data attributes for theme switching.
    static func highlighterThemeMetaLinks(for themes: some Collection<HighlighterTheme>) -> some HeadElement {
        HeadForEach(themes.sorted()) { theme in
            MetaLink(href: "/\(theme.url)", rel: .stylesheet)
                .data("highlight-theme", theme.description)
        }
    }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The target of this link.
    var href: String

    /// The relationship of this link to the current page.
    var rel: String

    /// Creates a new `MetaLink` object using the target and relationship provided.
    /// - Parameters:
    ///   - href: The location of the resource in question.
    ///   - rel: How this resource relates to the current page.
    public init(href: String, rel: String) {
        self.href = href
        self.rel = rel
    }

    /// Creates a new `MetaLink` object using the target and relationship provided.
    /// - Parameters:
    ///   - href: The location of the resource in question.
    ///   - rel: How this resource relates to the current page.
    public init(href: URL, rel: String) {
        self.href = href.absoluteString
        self.rel = rel
    }

    /// Creates a new `MetaLink` object using the target and relationship provided.
    /// - Parameters:
    ///   - href: The location of the resource in question.
    ///   - rel: How this resource relates to the current page.
    public init(href: String, rel: LinkRelationship) {
        self.href = href
        self.rel = rel.rawValue
    }

    /// Creates a new `MetaLink` object using the target and relationship provided.
    /// - Parameters:
    ///   - href: The location of the resource in question.
    ///   - rel: How this resource relates to the current page.
    public init(href: URL, rel: LinkRelationship) {
        self.href = href.absoluteString
        self.rel = rel.rawValue
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    ///
    /// If the link `href` starts with a `\` it is an asset and requires any `subsite` prepended;
    /// otherwise the `href` is a URL and  doesn't get `subsite` prepended
    public func render() -> Markup {
        var attributes = attributes
        // char[0] of the link 'href' is '/' for an asset; not for a site URL
        let basePath = href.starts(with: "/") ? publishingContext.site.url.path : ""
        attributes.append(customAttributes:
            .init(name: "href", value: "\(basePath)\(href)"),
            .init(name: "rel", value: rel))

        return Markup("<link\(attributes) />")
    }
}

public extension MetaLink {
    /// Adds a data attribute to the element.
    /// - Parameters:
    ///   - name: The name of the data attribute
    ///   - value: The value of the data attribute
    /// - Returns: The modified `MetaLink`
    func data(_ name: String, _ value: String) -> Self {
        var copy = self
        copy.attributes.data.append(.init(name: name, value: value))
        return copy
    }

    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func customAttribute(name: String, value: String) -> Self {
        var copy = self
        copy.attributes.append(customAttributes: .init(name: name, value: value))
        return copy
    }
}
