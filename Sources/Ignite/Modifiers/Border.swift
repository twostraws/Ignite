//
// Border.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor private func borderModifier(
    color: Color,
    width: Double,
    style: BorderStyle,
    edges: Edge,
    content: any HTML
) -> any HTML {
    let styles = createBorderStyles(color: color, width: width, style: style, edges: edges)
    return content.style(styles)
}

@MainActor private func borderModifier(
    color: Color,
    width: Double,
    style: BorderStyle,
    edges: Edge,
    content: any InlineElement
) -> any InlineElement {
    let styles = createBorderStyles(color: color, width: width, style: style, edges: edges)
    return content.style(styles)
}

private func createBorderStyles(
    color: Color,
    width: Double,
    style: BorderStyle,
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

    return styles
}

public extension HTML {
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
    ) -> some HTML {
        return AnyHTML(borderModifier(
            color: color,
            width: width,
            style: style,
            edges: edges,
            content: self
        ))
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
        return AnyInlineElement(borderModifier(
            color: color,
            width: width,
            style: style,
            edges: edges,
            content: self
        ))
    }
}

public extension StyledHTML {
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
    ) -> Self {
        return self.style(createBorderStyles(
            color: color,
            width: width,
            style: style,
            edges: edges
        ))
    }
}
