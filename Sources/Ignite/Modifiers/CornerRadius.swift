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
        AnyHTML(cornerRadiusModifier(edges: edges, length: length))
    }

    /// Rounds selected edges of this object by some number of pixels.
    /// - Parameters:
    ///   - edges: Which corners should be rounded
    ///   - length: An integer specifying a pixel amount to round corners with
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ edges: DiagonalEdge, _ length: Int) -> some HTML {
        AnyHTML(cornerRadiusModifier(edges: edges, length: .px(length)))
    }
}

private extension HTML {
    func cornerRadiusModifier(edges: DiagonalEdge, length: LengthUnit) -> any HTML {
        if edges.contains(.all) {
            return self.style(.borderRadius, "\(length)")
        }

        var modified: any HTML = self

        if edges.contains(.topLeading) {
            modified = modified.style(.borderTopLeftRadius, length.stringValue)
        }

        if edges.contains(.topTrailing) {
            modified = modified.style(.borderTopRightRadius, length.stringValue)
        }

        if edges.contains(.bottomLeading) {
            modified = modified.style(.borderBottomLeftRadius, length.stringValue)
        }

        if edges.contains(.bottomTrailing) {
            modified = modified.style(.borderBottomRightRadius, length.stringValue)
        }

        return modified
    }
}
