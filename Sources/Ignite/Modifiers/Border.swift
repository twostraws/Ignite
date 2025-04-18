//
// Border.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
private func borderModifier(
    color: Color,
    width: Double,
    style: BorderStyle,
    cornerRadii: CornerRadii,
    edges: Edge,
    content: any HTML
) -> any HTML {
    let styles = createBorderStyles(color: color, width: width, style: style, cornerRadii: cornerRadii, edges: edges)
    return content.style(styles)
}

@MainActor
private func borderModifier(
    color: Color,
    width: Double,
    style: BorderStyle,
    cornerRadii: CornerRadii,
    edges: Edge,
    content: any InlineElement
) -> any InlineElement {
    let styles = createBorderStyles(color: color, width: width, style: style, cornerRadii: cornerRadii, edges: edges)
    return content.style(styles)
}

private func createBorderStyles(
    color: Color,
    width: Double,
    style: BorderStyle,
    cornerRadii: CornerRadii,
    edges: Edge
) -> [InlineStyle] {
    var styles = [InlineStyle]()
    if edges.contains(.all) {
        styles.append(.init(.border, value: "\(width)px \(style.rawValue) \(color)"))
    } else {
        if edges.contains(.leading) {
            styles.append(.init(.borderLeft, value: "\(width)px \(style.rawValue) \(color)"))
        }
        if edges.contains(.trailing) {
            styles.append(.init(.borderRight, value: "\(width)px \(style.rawValue) \(color)"))
        }
        if edges.contains(.top) {
            styles.append(.init(.borderTop, value: "\(width)px \(style.rawValue) \(color)"))
        }
        if edges.contains(.bottom) {
            styles.append(.init(.borderBottom, value: "\(width)px \(style.rawValue) \(color)"))
        }
    }

    if cornerRadii.topLeading > 0 {
        styles.append(.init(.borderTopLeftRadius, value: "\(cornerRadii.topLeading)px"))
    }
    if cornerRadii.topTrailing > 0 {
        styles.append(.init(.borderTopRightRadius, value: "\(cornerRadii.topTrailing)px"))
    }
    if cornerRadii.bottomLeading > 0 {
        styles.append(.init(.borderBottomLeftRadius, value: "\(cornerRadii.bottomLeading)px"))
    }
    if cornerRadii.bottomTrailing > 0 {
        styles.append(.init(.borderBottomRightRadius, value: "\(cornerRadii.bottomTrailing)px"))
    }

    return styles
}

public extension Element {
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
    ) -> some Element {
        AnyHTML(borderModifier(
            color: color,
            width: width,
            style: style,
            cornerRadii: cornerRadii,
            edges: edges,
            content: self))
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
        AnyInlineElement(borderModifier(
            color: color,
            width: width,
            style: style,
            cornerRadii: cornerRadii,
            edges: edges,
            content: self))
    }
}

public extension StyledHTML {
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
    ) -> Self {
        let styles = createBorderStyles(
            color: color,
            width: width,
            style: style,
            cornerRadii: cornerRadii,
            edges: edges)
        return self.style(styles)
    }
}
