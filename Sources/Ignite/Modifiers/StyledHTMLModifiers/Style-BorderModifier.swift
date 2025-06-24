//
// Style-BorderModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

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
        let styles = BorderModifier.styles(color: color, width: width, style: style, edges: edges)
        return self.style(styles)
    }
}
