//
// CornerRadiusModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies corner radius styling to HTML elements.
struct CornerRadiusModifier: HTMLModifier {
    /// The corners to round.
    var edges: DiagonalEdge
    /// The radius length value.
    var length: LengthUnit

    func body(content: Content) -> some HTML {
        var modified = content
        let styles = Self.styles(edges: edges, length: length)
        modified.attributes.append(styles: styles)
        return modified
    }

    /// Generates CSS border-radius styles for the specified edges and length.
    /// - Parameters:
    ///   - edges: The corners to round
    ///   - length: The radius value
    /// - Returns: An array of inline styles for border radius
    static func styles(edges: DiagonalEdge, length: LengthUnit) -> [InlineStyle] {
        var styles = [InlineStyle]()

        if edges.contains(.all) {
            styles.append(.init(.borderRadius, value: "\(length)"))
            return styles
        }

        if edges.contains(.topLeading) {
            styles.append(.init(.borderTopLeftRadius, value: length.stringValue))
        }

        if edges.contains(.topTrailing) {
            styles.append(.init(.borderTopRightRadius, value: length.stringValue))
        }

        if edges.contains(.bottomLeading) {
            styles.append(.init(.borderBottomLeftRadius, value: length.stringValue))
        }

        if edges.contains(.bottomTrailing) {
            styles.append(.init(.borderBottomRightRadius, value: length.stringValue))
        }

        return styles
    }
}

public extension HTML {
    /// Rounds all edges of this object by some value specified as a string.
    /// - Parameter length: A string with rounding of your choosing, such as "50%".
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ length: LengthUnit) -> some HTML {
        modifier(CornerRadiusModifier(edges: .all, length: length))
    }

    /// Rounds all edges of this object by some number of pixels.
    /// - Parameter length: An integer specifying a pixel amount to round corners with.
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ length: Int) -> some HTML {
        modifier(CornerRadiusModifier(edges: .all, length: .px(length)))
    }

    /// Rounds selected edges of this object by some value specified as a string.
    /// - Parameters:
    ///   - edges: Which corners should be rounded
    ///   - length: A string with rounding of your choosing, such as "50%"
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ edges: DiagonalEdge, _ length: LengthUnit) -> some HTML {
        modifier(CornerRadiusModifier(edges: edges, length: length))
    }

    /// Rounds selected edges of this object by some number of pixels.
    /// - Parameters:
    ///   - edges: Which corners should be rounded
    ///   - length: An integer specifying a pixel amount to round corners with
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ edges: DiagonalEdge, _ length: Int) -> some HTML {
        modifier(CornerRadiusModifier(edges: edges, length: .px(length)))
    }
}
