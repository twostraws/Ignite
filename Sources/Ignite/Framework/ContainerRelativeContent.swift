//
// ContainerRelativeContent.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A flex container that positions content relative to its container bounds.
struct ContainerRelativeContent<Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The content to be positioned within the container.
    private var content: Content

    /// The alignment strategy for positioning content.
    private var alignment: Alignment

    /// CSS rules that anchor the container to all edges.
    private let edgeAlignmentRules: [InlineStyle] = [
        .init(.top, value: "0"),
        .init(.right, value: "0"),
        .init(.bottom, value: "0"),
        .init(.left, value: "0")
    ]

    /// Creates a container with the specified content and alignment.
    /// - Parameters:
    ///   - content: The HTML content to position.
    ///   - alignment: How to align the content within the container.
    init(_ content: Content, alignment: Alignment) {
        self.content = content
        self.alignment = alignment
    }

    /// Renders the container with positioned content as HTML markup.
    func render() -> Markup {
        let content = content
            .style(.marginBottom, "0")
            .style(alignment.itemAlignmentRules)

        let finalContent: any HTML = if content.requiresPositioningContext {
            Section(content)
        } else {
            content
        }

        return finalContent
            .attributes(attributes)
            .style(.display, "flex")
            .style(self is any ImageProvider ? .init(.flexDirection, value: "column") : nil)
            .style(.overflow, "hidden")
            .style(edgeAlignmentRules)
            .style(alignment.flexAlignmentRules)
            .style(.width, "100%")
            .style(.height, "100%")
            .render()
    }
}
