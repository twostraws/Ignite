//
// CornerRadius.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Rounds all edges of this object by some value specified as a string.
    /// - Parameter length: A string with rounding of your choosing, such as "50%".
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ length: LengthUnit) -> some HTML {
        cornerRadius(.all, length)
    }

    /// Rounds all edges of this object by some number of pixels.
    /// - Parameter length: An integer specifying a pixel amount to round corners with.
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ length: Int) -> some HTML {
        cornerRadius(.all, length)
    }

    /// Rounds selected edges of this object by some value specified as a string.
    /// - Parameters:
    ///   - edges: Which corners should be rounded
    ///   - length: A string with rounding of your choosing, such as "50%"
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ edges: DiagonalEdge, _ length: LengthUnit) -> some HTML {
        let cornerRadiusStyles = cornerRadiusModifier(edges: edges, length: length)
        return AnyHTML(self.style(cornerRadiusStyles))
    }

    /// Rounds selected edges of this object by some number of pixels.
    /// - Parameters:
    ///   - edges: Which corners should be rounded
    ///   - length: An integer specifying a pixel amount to round corners with
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ edges: DiagonalEdge, _ length: Int) -> some HTML {
        let cornerRadiusStyles = cornerRadiusModifier(edges: edges, length: .px(length))
        return AnyHTML(self.style(cornerRadiusStyles))
    }
}

private func cornerRadiusModifier(edges: DiagonalEdge, length: LengthUnit) -> [InlineStyle] {
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
