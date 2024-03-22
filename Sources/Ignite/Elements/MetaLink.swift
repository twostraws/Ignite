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

    /// The CSS you should include for Ignite pages that use system icons.
    public static let iconCSS = MetaLink(href: "/css/bootstrap-icons.min.css", rel: "stylesheet")

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
    public func render(context: PublishingContext) -> String {
        "<link href=\"\(href)\" rel=\"\(rel)\">"
    }
}
