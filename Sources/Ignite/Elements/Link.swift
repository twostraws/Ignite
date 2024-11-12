//
// Link.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A hyperlink to another resource on this site or elsewhere.
public struct Link: BlockElement, InlineElement, NavigationItem, DropdownElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth: ColumnWidth = .automatic

    /// Describes what kind of link this is.
    public enum Relationship: String {
        /// Alternate versions of this current code.
        case alternate = "alternate"

        /// An augmented-reality resource for this page.
        case ar = "ar" // swiftlint:disable:this identifier_name

        /// A link to the creator of this page.
        case author = "author"

        /// A permanent link for this page.
        case bookmark = "bookmark"

        /// Marks that this is the preferred URL for this resource.
        case canonical = "canonical"

        /// Instructs the browser to look up DNS details for this
        /// resource immediately.
        case dnsPrefetch = "dns-prefetch"

        /// Marks that this resource belongs to a different site.
        case external = "external"

        /// This resource points to further help about this page.
        case help = "help"

        /// An icon representing this document.
        case icon = "icon"

        /// This link points to a specific license that applies to the current page.
        case license = "license"

        /// This link points to the web app manifest for the current page.
        case manifest = "manifest"

        /// Used for links about a person when they point to other pages about
        /// the same person.
        case me = "me" // swiftlint:disable:this identifier_name

        /// Instructs the browser to preload a script immediately.
        case modulePreload = "modulepreload"

        /// Marks this document as being part of a series, where the next
        /// document is contained in this link.
        case next = "next"

        /// Indicates to search engines that this link should not be followed,
        /// This is helpful when linking to external sites – if they do something
        /// that Google et al frown upon the future, that won't somehow affect
        /// your site ranking.
        case noFollow = "nofollow"

        /// Adds an extra layer of security when opening links to resources
        /// not owned by you, by disallowing them to access JavaScript's
        /// `window.opener` property.
        case noOpener = "noopener"

        /// Disables the HTTP referrer header from being included, and
        /// also includes `.noOpener`.
        case noReferrer = "noreferrer"

        /// Pages opened with this attribute are allowed have control over
        /// the original page, such as changing its URL. Please use with care.
        case opener = "opener"

        /// Provides the address of the server that handles pingback events for
        /// the current page.
        case pingback = "pingback"

        /// Instructs the browser to immediately make a connection to the server
        /// providing this resource. Useful when you know data from there will
        /// be accessed very soon.
        case preconnect = "preconnect"

        /// Instructs the browser to immediately fetch the linked data. Useful when
        /// you know the data will be needed immediately.
        case prefetch = "prefetch"

        /// Instructs the browser to immediately fetch and fully process the
        /// linked data. Useful when you know the data will be needed immediately.
        case prerender = "prerender"

        /// Marks this document as being part of a series, where the previous
        /// document is contained in this link.
        case prev = "previous"

        /// This link points to the privacy policy for the current page.
        case privacyPolicy = "privacy-policy"

        /// This link points to the search page for your site.
        case search = "search"

        /// Brings a CSS file into your page.
        case stylesheet = "stylesheet"

        /// Marks this link as pointing to a page consisting of content belonging
        /// to a particular tag string.
        case tag = "tag"

        /// This link points to the legal terms of service for the current page.
        case termsOfService = "terms-of-service"
    }

    /// Controls where this link should be opened, e.g. in the current browser
    /// window or in a new window.
    public enum Target {
        /// No location is specified, which usually means the link opens in
        /// the current browser window.
        case `default`

        /// The page should be opened in a new window.
        case blank

        /// The page should be opened in a new window. (same as `.blank`)`
        case newWindow

        /// The page should be opened in the parent window.
        case parent

        /// The page should be opened at the top-most level in the user's
        /// browser. Used when your page is displayed inside a frame.
        case top

        /// Target a specific, named location.
        case custom(String)

        /// Converts enum cases to the matching HTML.
        var name: String? {
            switch self {
            case .default:
                nil
            case .blank, .newWindow:
                "_blank"
            case .parent:
                "_parent"
            case .top:
                "_top"
            case .custom(let name):
                name
            }
        }
    }

    /// Allows you to style links as buttons if needed.
    public enum LinkStyle: String, CaseIterable {
        case `default`, hover, button
    }
    
    /// The content to display inside this link.
    var content: any HTML

    /// The location to which this link should direct users.
    var url: String

    /// The style for this link. Defaults to `.default`.
    var style = LinkStyle.default

    /// When rendered with the `.button` style, this controls the button's size.
    var size = ButtonSize.medium

    /// The role of this link, which applies various styling effects.
    var role = Role.default

    /// Returns an array containing the correct CSS classes to style this link.
    var linkClasses: [String] {
        var outputClasses = [String]()

        if style == .button {
            outputClasses.append(contentsOf: Button.classes(forRole: role, size: size))
        } else {
            if role == .none {
                outputClasses.append("link-plain")
            } else if role != .default {
                outputClasses.append("link-\(role.rawValue)")
            }
            if style == .hover {
                outputClasses.append(contentsOf: [
                    "link-underline-opacity-0",
                    "link-underline-opacity-100-hover"
                ])
            }
        }

        return outputClasses
    }

    /// Creates a `Link` instance from the content you provide, linking to the
    /// URL specified.
    /// - Parameters:
    ///   - target: The URL you want to link to.
    ///   - content: The user-facing content to show inside the `Link`.
    public init(target: String, @HTMLBuilder content: @escaping () -> some HTML) {
        self.content = content()
        self.url = target
        self.role = .none
    }

    /// Creates a Link wrapping the provided content and pointing to the given page
    /// - Parameters:
    ///  - target: The new target to apply.
    ///  - content: The user-facing content to show inside the `Link`.
    /// - Returns: A new `Link` instance with the updated target.
    public init(target: any StaticPage, @HTMLBuilder content: @escaping () -> some HTML) {
        self.content = content()
        self.url = target.path
        self.role = .none
    }

    /// Controls in which window this page should be opened.
    /// - Parameter target: The new target to apply.
    /// - Returns: A new `Link` instance with the updated target.
    public func target(_ target: Target) -> Self {
        if let name = target.name {
            var copy = self
            let attribute = AttributeValue(name: "target", value: name)
            copy.attributes.customAttributes.insert(attribute)
            return copy
        } else {
            return self
        }
    }

    /// Adjusts the style of this link, when rendered in the `.button` style.
    /// - Parameter size: The new style.
    /// - Returns: A new `Link` instance with the updated size.
    public func buttonSize(_ size: ButtonSize) -> Self {
        var copy = self
        copy.size = size
        return copy
    }

    /// Adjusts the role of this link.
    /// - Parameter role: The new role.
    /// - Returns: A new `Link` instance with the updated role.
    public func role(_ role: Role) -> Self {
        var copy = self
        copy.role = role
        return copy
    }

    /// Adjusts the style of this link.
    /// - Parameter style: The new style.
    /// - Returns: A new `Link` instance with the updated style.
    public func linkStyle(_ style: LinkStyle) -> Self {
        var copy = self
        copy.style = style

        // If there isn't already a role for this link,
        // add one automatically so it has sensible
        // default button styling.
        if copy.role == .default {
            copy.role = .primary
        }

        return copy
    }

    /// Sets one or more relationships for this link, which provides metadata
    /// describing what this content means or how it should be used.
    /// - Parameter relationship: The extra relationships to add.
    /// - Returns: A new `Link` instance with the updated relationships.
    public func relationship(_ relationship: Relationship...) -> Self {
        var copy = self
        let attributeValue = relationship.map(\.rawValue).joined(separator: " ")
        let attribute = AttributeValue(name: "rel", value: attributeValue)
        copy.attributes.customAttributes.insert(attribute)
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        isPrivacySensitive
            ? renderPrivacyProtectedLink(context: context)
            : renderStandardLink(context: context)
    }

    /// Whether this link contains sensitive content that should be protected
    private var isPrivacySensitive: Bool {
        attributes.customAttributes.contains { $0.name == "privacy-sensitive" }
    }

    /// Renders a link with privacy protection enabled, encoding the URL and optionally the display content.
    /// - Parameter context: The current publishing context.
    /// - Returns: An HTML anchor tag with encoded attributes and content.
    private func renderPrivacyProtectedLink(context: PublishingContext) -> String {
        let displayText = content.render(context: context)
        let encodingType = attributes.customAttributes.first { $0.name == "privacy-sensitive" }?.value ?? "urlOnly"

        let encodedUrl = Data(url.utf8).base64EncodedString()
        let displayContent = switch encodingType {
        case "urlAndDisplay": Data(displayText.utf8).base64EncodedString()
        default: displayText
        }

        var linkAttributes = attributes.appending(classes: linkClasses)
        linkAttributes.classes.append("protected-link")
        linkAttributes.data.insert(AttributeValue(name: "encoded-url", value: encodedUrl))

        return """
        <a href="#"\(linkAttributes.description)>\(displayContent)</a>
        """
    }

    /// Renders a standard link with the provided URL and content.
    /// - Parameter context: The current publishing context.
    /// - Returns: An HTML anchor tag with the appropriate href and content.
    private func renderStandardLink(context: PublishingContext) -> String {
        let linkAttributes = attributes.appending(classes: linkClasses)

        // char[0] of the 'url' is '/' for an asset; not for a site URL
        let basePath = url.starts(with: "/") ? context.site.url.path : ""
        return """
        <a href=\"\(basePath)\(url)\"\(linkAttributes.description)>\
        \(content.render(context: context))\
        </a>
        """
    }
}

// Extension for traditional inline links
public extension Link {
    /// Creates a `Link` instance from the content you provide, linking to the
    /// URL specified.
    /// - Parameters:
    ///   - content: The user-facing content to show inside the `Link`.
    ///   - target: The URL you want to link to.
    init(_ content: some HTML, target: String) {
        self.content = content
        self.url = target
    }

    /// Creates a `Link` instance from the content you provide, linking to the path
    /// belonging to the specified `Page`.
    /// - Parameters:
    ///   - content: The user-facing content to show inside the `Link`.
    ///   - target: The `Page` you want to link to.
    init(_ content: some InlineElement, target: any StaticPage) {
        self.content = content
        self.url = target.path
    }

    /// Creates a `Link` instance from the content you provide, linking to the
    /// URL specified.
    /// - Parameters:
    ///   - content: The user-facing content to show inside the `Link`.
    ///   - target: The URL you want to link to.
    init(_ content: String, target: URL) {
        self.content = content
        self.url = target.absoluteString
    }

    /// Convenience initializer that creates a new `Link` instance using the
    /// title and path of the `MarkdownContent` instance you provide.
    /// - Parameter content: A piece of content from your site.
    init(_ content: MarkdownContent) {
        self.content = content.title
        self.url = content.path
    }
}
