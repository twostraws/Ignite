//
// BorderInlineModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies border styling to inline elements.
private struct BorderInlineModifier: InlineElementModifier {
    /// The border color.
    var color: Color
    /// The border width in pixels.
    var width: Double
    /// The border style.
    var style: BorderStyle
    /// The edges to apply the border to.
    var edges: Edge

    func body(content: Content) -> some InlineElement {
        var modified = content
        let styles = BorderModifier.styles(color: color, width: width, style: style, edges: edges)
        modified.attributes.append(styles: styles)
        return modified
    }
}

public extension InlineElement {
    /// Adds a border to this element.
    /// - Parameters:
    ///   - color: The color of the border
    ///   - width: The width in pixels
    ///   - style: The border style
    ///   - edges: Which edges should have borders
    /// - Returns: A modified element with the border applied
    func border(
        _ color: Color,
        width: Double = 1,
        style: BorderStyle = .solid,
        edges: Edge = .all
    ) -> some InlineElement {
        modifier(BorderInlineModifier(color: color, width: width, style: style, edges: edges))
    }
}
