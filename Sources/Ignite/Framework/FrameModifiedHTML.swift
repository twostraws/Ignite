//
// FrameModifiedHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A wrapper that applies frame constraints and alignment to HTML content.
///
/// Frame modifications allow you to control the sizing and positioning of HTML elements
/// by setting width, height, and alignment properties.
struct FrameModifiedHTML<Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The HTML content to be framed.
    var content: Content

    /// The minimum width constraint.
    var minWidth: LengthUnit?

    /// The width constraint.
    var width: LengthUnit?

    /// The maximum width constraint.
    var maxWidth: LengthUnit?

    /// The minimum height constraint.
    var minHeight: LengthUnit?

    /// The height constraint.
    var height: LengthUnit?

    /// The maximum height constraint.
    var maxHeight: LengthUnit?

    /// The alignment for positioning the content within the frame.
    var alignment: Alignment?

    /// Renders the framed content as HTML markup.
    /// - Returns: The rendered HTML markup with applied frame modifications.
    func render() -> Markup {
        var dimensions = [InlineStyle]()

        if let minWidth {
            dimensions.append(.init(.minWidth, value: minWidth.stringValue))
        }

        if let width {
            dimensions.append(.init(.width, value: width.stringValue))
        }

        if let maxWidth {
            if width == nil {
                // If no width has been explicitly set, allow content
                // to scale with screen sizes smaller than the max width
                // as a sensible default
                dimensions.append(.init(.width, value: "100%"))
            }
            dimensions.append(.init(.maxWidth, value: maxWidth.stringValue))
        }

        if let minHeight {
            dimensions.append(.init(.minHeight, value: minHeight.stringValue))
        }

        if let height {
            dimensions.append(.init(.height, value: height.stringValue))
        }

        if let maxHeight {
            dimensions.append(.init(.maxHeight, value: maxHeight.stringValue))
        }

        guard let alignment else {
            // Apply the frame to the modified element directly
            return content
                .attributes(attributes)
                .style(dimensions)
                .render()
        }

        // Create a positioning context with the specified frame for the modified element
        return Section {
            content
                .style(alignment.itemAlignmentRules)
                .style(content is any ImageProvider ? dimensions : [])
        }
        .attributes(attributes)
        .style(.display, "flex")
        .style(content is any ImageProvider ? .init(.flexDirection, value: "column") : nil)
        .style(.overflow, "hidden")
        .style(alignment.flexAlignmentRules)
        .style(dimensions)
        .render()
    }
}
