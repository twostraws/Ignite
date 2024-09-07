//
// MetaLink.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// An item of metadata that links to an external resource somehow, such as
/// a stylesheet.
public struct MetaLink: HeadElement {
    /// The standard CSS you should include on all Ignite pages.
    public static let standardCSS = MetaLink(href: "/css/bootstrap.min.css", rel: "stylesheet")
    
    /// The standard CSS you should include on all Ignite pages if using remote Bootstrap files
    public static let standardRemoteCSS = MetaLink(href: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css", rel: "stylesheet")
                        .addCustomAttribute(name: "integrity", value: "sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH")
                        .addCustomAttribute(name: "crossorigin", value: "anonymous")

    /// The CSS you should include for Ignite pages that use system icons.
    public static let iconCSS = MetaLink(href: "/css/bootstrap-icons.min.css", rel: "stylesheet")
    
    /// The CSS you should include for Ignite pages that use system icons if using Bootstrap from a CDN.
    public static let remoteIconCSS = MetaLink(href: "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css", rel: "stylesheet")

    /// The standard CSS you should include on all pages that use syntax highlighting.
    public static let syntaxHighlightingCSS = MetaLink(href: "/css/prism-default-dark.css", rel: "stylesheet")

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
    public init(href: String, rel: Link.Relationship) {
        self.href = href
        self.rel = rel.rawValue
    }

    /// Creates a new `MetaLink` object using the target and relationship provided.
    /// - Parameters:
    ///   - href: The location of the resource in question.
    ///   - rel: How this resource relates to the current page.
    public init(href: URL, rel: Link.Relationship) {
        self.href = href.absoluteString
        self.rel = rel.rawValue
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    ///
    /// If the link `href` starts with a `\` it is an asset and requires any `subsite` prepended;
    /// otherwise the `href` is a URL and  doesn't get `subsite` prepended
    public func render(context: PublishingContext) -> String {
        // char[0] of the link 'href' is '/' for an asset; not for a site URL
        let basePath = href.starts(with: "/") ? context.site.url.path : ""
        return "<link href=\"\(basePath)\(href)\" rel=\"\(rel)\">"
    }
}
