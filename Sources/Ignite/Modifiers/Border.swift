//
// Border.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

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
        AnyHTML(borderModifier(color: color, width: width, style: style, cornerRadii: cornerRadii, edges: edges))
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
        AnyHTML(borderModifier(color: color, width: width, style: style, cornerRadii: cornerRadii, edges: edges))
    }
}

private extension HTML {
    func borderModifier(
        color: Color, width: Double,
        style: BorderStyle,
        cornerRadii: CornerRadii,
        edges: Edge
    ) -> any HTML {
        var modified: any HTML = self
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
