//
// Border.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private struct BorderConfig {
    let color: Color
    let width: Double
    let style: BorderStyle
    let cornerRadii: CornerRadii
    let edges: Edge

    init(
        color: Color,
        width: Double = 1,
        style: BorderStyle = .solid,
        cornerRadii: CornerRadii = CornerRadii(),
        edges: Edge = .all
    ) {
        self.color = color
        self.width = width
        self.style = style
        self.cornerRadii = cornerRadii
        self.edges = edges
    }
}

@MainActor
private func borderModifier(config: BorderConfig, content: any Element) -> any Element {
    let styles = createBorderStyles(config: config)
    return content.style(styles)
}

@MainActor
private func borderModifier(config: BorderConfig, content: any InlineElement) -> any InlineElement {
    let styles = createBorderStyles(config: config)
    return content.style(styles)
}

private func createBorderStyles(config: BorderConfig) -> [InlineStyle] {
    var styles = [InlineStyle]()
    if config.edges.contains(.all) {
        styles.append(.init(.border, value: "\(config.width)px \(config.style.rawValue) \(config.color)"))
    } else {
        if config.edges.contains(.leading) {
            styles.append(.init(.borderLeft, value: "\(config.width)px \(config.style.rawValue) \(config.color)"))
        }
        if config.edges.contains(.trailing) {
            styles.append(.init(.borderRight, value: "\(config.width)px \(config.style.rawValue) \(config.color)"))
        }
        if config.edges.contains(.top) {
            styles.append(.init(.borderTop, value: "\(config.width)px \(config.style.rawValue) \(config.color)"))
        }
        if config.edges.contains(.bottom) {
            styles.append(.init(.borderBottom, value: "\(config.width)px \(config.style.rawValue) \(config.color)"))
        }
    }

    if config.cornerRadii.topLeading > 0 {
        styles.append(.init(.borderTopLeftRadius, value: "\(config.cornerRadii.topLeading)px"))
    }
    if config.cornerRadii.topTrailing > 0 {
        styles.append(.init(.borderTopRightRadius, value: "\(config.cornerRadii.topTrailing)px"))
    }
    if config.cornerRadii.bottomLeading > 0 {
        styles.append(.init(.borderBottomLeftRadius, value: "\(config.cornerRadii.bottomLeading)px"))
    }
    if config.cornerRadii.bottomTrailing > 0 {
        styles.append(.init(.borderBottomRightRadius, value: "\(config.cornerRadii.bottomTrailing)px"))
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
        let config = BorderConfig(
            color: color,
            width: width,
            style: style,
            cornerRadii: cornerRadii,
            edges: edges
        )
        return AnyHTML(borderModifier(config: config, content: self))
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
        let config = BorderConfig(
            color: color,
            width: width,
            style: style,
            cornerRadii: cornerRadii,
            edges: edges
        )
        return AnyInlineElement(borderModifier(config: config, content: self))
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
        let config = BorderConfig(
            color: color,
            width: width,
            style: style,
            cornerRadii: cornerRadii,
            edges: edges
        )
        return self.style(createBorderStyles(config: config))
    }
}
