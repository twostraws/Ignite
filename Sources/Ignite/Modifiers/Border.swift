//
// Border.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies border styling to HTML elements.
struct BorderModifier: HTMLModifier {
    /// The color of the border.
    var color: Color

    /// The width of the border in pixels.
    var width: Double

    /// The style of the border.
    var style: BorderStyle

    /// The radii for rounding corners.
    var cornerRadii: CornerRadii

    /// Which edges should have borders.
    var edges: Edge

    /// Applies the border styling to the provided HTML content.
    /// - Parameter content: The HTML content to modify
    /// - Returns: The modified HTML content with border styling applied
    func body(content: some HTML) -> any HTML {
        // Apply border styles based on edges
        var modified: any HTML = content
        if edges.contains(.all) {
            modified = modified.style(.border, "\(width)px \(style.rawValue) \(color)")
        } else {
            if edges.contains(.leading) {
                modified = modified.style(.borderLeft, "\(width)px \(style.rawValue) \(color)")
            }
            if edges.contains(.trailing) {
                modified = modified.style(.borderRight, "\(width)px \(style.rawValue) \(color)")
            }
            if edges.contains(.top) {
                modified = modified.style(.borderTop, "\(width)px \(style.rawValue) \(color)")
            }
            if edges.contains(.bottom) {
                modified = modified.style(.borderBottom, "\(width)px \(style.rawValue) \(color)")
            }
        }

        // Apply corner radii
        if cornerRadii.topLeading > 0 {
            modified = modified.style(.borderTopLeftRadius, "\(cornerRadii.topLeading)px")
        }
        if cornerRadii.topTrailing > 0 {
            modified = modified.style(.borderTopRightRadius, "\(cornerRadii.topTrailing)px")
        }
        if cornerRadii.bottomLeading > 0 {
            modified = modified.style(.borderBottomLeftRadius, "\(cornerRadii.bottomLeading)px")
        }
        if cornerRadii.bottomTrailing > 0 {
            modified = modified.style(.borderBottomRightRadius, "\(cornerRadii.bottomTrailing)px")
        }

        return modified
    }
}

public extension HTML {
    /// Adds a border to this element.
    /// - Parameters:
    ///   - color: The color of the border
    ///   - width: The width in pixels
    ///   - style: The border style
    ///   - cornerRadii: The corner rounding radii
    ///   - edges: Which edges should have borders
    /// - Returns: A modified element with the border applied
    func border(
        _ color: Color,
        width: Double = 1,
        style: BorderStyle = .solid,
        cornerRadii: CornerRadii = CornerRadii(),
        edges: Edge = .all
    ) -> some HTML {
        modifier(BorderModifier(
            color: color,
            width: width,
            style: style,
            cornerRadii: cornerRadii,
            edges: edges)
        )
    }
}

public extension InlineElement {
    /// Adds a border to this element.
    /// - Parameters:
    ///   - color: The color of the border
    ///   - width: The width in pixels
    ///   - style: The border style
    ///   - cornerRadii: The corner rounding radii
    ///   - edges: Which edges should have borders
    /// - Returns: A modified element with the border applied
    func border(
        _ color: Color,
        width: Double = 1,
        style: BorderStyle = .solid,
        cornerRadii: CornerRadii = CornerRadii(),
        edges: Edge = .all
    ) -> some InlineElement {
        modifier(BorderModifier(
            color: color,
            width: width,
            style: style,
            cornerRadii: cornerRadii,
            edges: edges)
        )
    }
}
