//
// ContentPreview.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A protocol for customizing the layout of ContentPreview.
public protocol ContentPreviewStyle {
    func body(content: Content, context: PublishingContext) -> any BlockHTML
}

/// A wrapper around Card, specifically aimed at presenting details about
/// some content on your site. This automatically links to your content page
/// and adds in tags.
public struct ContentPreview: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    var content: Content

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// Custom style for the content preview.
    private var style: ContentPreviewStyle?

    /// Initializes the content preview
    /// - Parameters:
    ///   - content: The content to display.
    public init(for content: Content) {
        self.content = content
    }

    public func contentPreviewStyle<S: ContentPreviewStyle>(_ style: S) -> ContentPreview {
        var copy = self
        copy.style = style
        return copy
    }

    /// Renders the content preview with either a custom layout or the default card.
    /// - Parameter context: The publishing context for rendering.
    /// - Returns: A rendered string of HTML.
    public func render(context: PublishingContext) -> String {
        // If custom style is provided, use it; otherwise,
        // fallback to default layout.
        if let style {
            style.body(content: content, context: context)
                .attributes(attributes)
                .render(context: context)
        } else {
            defaultCardLayout(context: context)
                .attributes(attributes)
                .render(context: context)
        }
    }

    /// Default card layout for rendering the content preview.
    /// - Parameter context: The publishing context for rendering tag links.
    /// - Returns: A BlockElement representing the card layout.
    private func defaultCardLayout(context: PublishingContext) -> some BlockHTML {
        Card(imageName: content.image) {
            Text(content.description)
                .margin(.bottom, .none)
        } header: {
            Text {
                Link(content)
            }
            .font(.title2)
        } footer: {
            let tagLinks = content.tagLinks(in: context)

            if tagLinks.isEmpty == false {
                Group {
                    tagLinks
                }
                .style("margin-top: -5px")
            }
        }
    }
}
