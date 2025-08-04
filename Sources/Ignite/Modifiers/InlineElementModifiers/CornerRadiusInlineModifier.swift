//
// CornerRadiusInlineModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies corner radius styling to HTML elements.
struct CornerRadiusInlineModifier: InlineElementModifier {
    /// The corners to round.
    var edges: DiagonalEdge
    /// The radius length value.
    var length: LengthUnit

    func body(content: Content) -> some InlineElement {
        var modified = content
        let styles = CornerRadiusModifier.styles(edges: edges, length: length)
        modified.attributes.append(styles: styles)
        return modified
    }
}

public extension InlineElement {
    /// Rounds all edges of this object by some value specified as a string.
    /// - Parameter length: A string with rounding of your choosing, such as "50%".
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ length: LengthUnit) -> some InlineElement {
        modifier(CornerRadiusInlineModifier(edges: .all, length: length))
    }

    /// Rounds all edges of this object by some number of pixels.
    /// - Parameter length: An integer specifying a pixel amount to round corners with.
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ length: Int) -> some InlineElement {
        modifier(CornerRadiusInlineModifier(edges: .all, length: .px(length)))
    }

    /// Rounds selected edges of this object by some value specified as a string.
    /// - Parameters:
    ///   - edges: Which corners should be rounded
    ///   - length: A string with rounding of your choosing, such as "50%"
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ edges: DiagonalEdge, _ length: LengthUnit) -> some InlineElement {
        modifier(CornerRadiusInlineModifier(edges: edges, length: length))
    }

    /// Rounds selected edges of this object by some number of pixels.
    /// - Parameters:
    ///   - edges: Which corners should be rounded
    ///   - length: An integer specifying a pixel amount to round corners with
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ edges: DiagonalEdge, _ length: Int) -> some InlineElement {
        modifier(CornerRadiusInlineModifier(edges: edges, length: .px(length)))
    }
}
