//
// Link.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A hyperlink to another resource on this site or elsewhere.
public struct Link: BlockHTML, InlineHTML, NavigationItem, DropdownElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a grid.
    public var columnWidth: ColumnWidth = .automatic

    /// The visual style to apply to the link.
    public enum LinkStyle {
        /// A link with an underline effect.
        /// - Parameters:
        ///   - base: The underline prominence in the link's normal state.
        ///   - hover: The underline prominence when hovering over the link.
        case underline(_ base: UnderlineProminence, hover: UnderlineProminence)

        /// A link that appears and behaves like a button.
        case button

        /// Creates an underline-style link with uniform prominence for both normal and hover states.
        /// - Parameter prominence: The underline prominence to use for both states.
        /// - Returns: A `LinkStyle` with identical base and hover prominence.
        public static func underline(_ prominence: UnderlineProminence) -> Self {
            .underline(prominence, hover: prominence)
        }

        /// The default link style with heavy underline prominence.
        public static var automatic: LinkStyle { .underline(.heavy, hover: .heavy) }
    }

    /// The content to display inside this link.
    var content: any HTML

    /// The location to which this link should direct users.
    var url: String

    /// The style for this link. Defaults to `.default`.
    var style = LinkStyle.automatic

    /// When rendered with the `.button` style, this controls the button's size.
    var size = Button.Size.medium

    /// The role of this link, which applies various styling effects.
    var role = Role.default

    /// Returns an array containing the correct CSS classes to style this link.
    var linkClasses: [String] {
        var outputClasses = [String]()

        switch style {
        case .button:
            outputClasses.append(contentsOf: Button.classes(forRole: role, size: size))
        case .underline(let baseDecoration, hover: let hoverDecoration):
            if role == .none {
                outputClasses.append("link-plain")
            } else if role != .default {
                outputClasses.append("link-\(role.rawValue)")
            }

            outputClasses.append("link-underline")
            outputClasses.append("link-underline-opacity-\(baseDecoration)")
            outputClasses.append("link-underline-opacity-\(hoverDecoration)-hover")
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
    public init(target: any StaticLayout, @HTMLBuilder content: @escaping () -> some HTML) {
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
            let attribute = Attribute(name: "target", value: name)
            copy.attributes.customAttributes.append(attribute)
            return copy
        } else {
            return self
        }
    }

    /// Adjusts the style of this link, when rendered in the `.button` style.
    /// - Parameter size: The new style.
    /// - Returns: A new `Link` instance with the updated size.
    public func buttonSize(_ size: Button.Size) -> Self {
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
        let attribute = Attribute(name: "rel", value: attributeValue)
        copy.attributes.customAttributes.append(attribute)
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        isPrivacySensitive
            ? renderPrivacyProtectedLink()
            : renderStandardLink()
    }

    /// Whether this link contains sensitive content that should be protected
    private var isPrivacySensitive: Bool {
        attributes.customAttributes.contains { $0.name == "privacy-sensitive" }
    }

    /// Renders a link with privacy protection enabled, encoding the URL and optionally the display content.
    /// - Parameter context: The current publishing context.
    /// - Returns: An HTML anchor tag with encoded attributes and content.
    private func renderPrivacyProtectedLink() -> String {
        let displayText = content.render()
        let encodingType = attributes.customAttributes.first { $0.name == "privacy-sensitive" }?.value ?? "urlOnly"

        let encodedUrl = Data(url.utf8).base64EncodedString()
        let displayContent = switch encodingType {
        case "urlAndDisplay": Data(displayText.utf8).base64EncodedString()
        default: displayText
        }

        var linkAttributes = attributes.appending(classes: linkClasses)
        linkAttributes.classes.append("protected-link")
        linkAttributes.data.append(Attribute(name: "encoded-url", value: encodedUrl))

        linkAttributes.tag = """
        a href="#"
        """
        linkAttributes.closingTag = "a"
        return linkAttributes.description(wrapping: displayContent)
    }

    /// Renders a standard link with the provided URL and content.
    /// - Returns: An HTML anchor tag with the appropriate href and content.
    private func renderStandardLink() -> String {
        var linkAttributes = attributes.appending(classes: linkClasses)

        // char[0] of the 'url' is '/' for an asset; not for a site URL
        let basePath = url.starts(with: "/") ? publishingContext.site.url.path : ""
        linkAttributes.tag = "a href=\"\(basePath)\(url)\""
        linkAttributes.closingTag = "a"
        return linkAttributes.description(wrapping: content.render())
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
    init(_ content: some InlineHTML, target: any StaticLayout) {
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
    init(_ content: Content) {
        self.content = content.title
        self.url = content.path
    }
}

extension Link {
    /// The type of HTML this element returns after attributes have been applied.
    public typealias AttributedHTML = Self

    public func id(_ id: String) -> Self {
        attributes.id(id)
        return self
    }

    public func `class`(_ classes: String...) -> Self {
        attributes.classes(classes)
        return self
    }
}
