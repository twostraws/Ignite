//
// ContentPreview.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A wrapper around Card, specifically aimed at presenting details about
/// some content on your site. This automatically links to your content page
/// and adds in tags.
public struct ContentPreview: BlockElement {
    var content: Content

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic
    public var customBlockElement: ((Content) -> BlockElement)?

    public init(for content: Content, customBlockElement: ((Content) -> BlockElement)? = nil) {
        self.content = content
        self.customBlockElement = customBlockElement
    }

    public func render(context: PublishingContext) -> String {
        if let customBlockElement {
            customBlockElement(content)
                .attributes(attributes)
                .render(context: context)
        } else {
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
            .attributes(attributes)
            .render(context: context)
        }
    }
}
