//
// Style-CornerRadius.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension StyledHTML {
    /// Rounds all edges of this object by some number of pixels.
    /// - Parameter length: An integer specifying a pixel amount to round corners with.
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ length: Int) -> Self {
        let styles = CornerRadiusModifier.styles(edges: .all, length: .px(length))
        return self.style(styles)
    }

    /// Rounds all edges of this object by some value specified as a string.
    /// - Parameter length: A string with rounding of your choosing, such as "50%".
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ length: LengthUnit) -> Self {
        let styles = CornerRadiusModifier.styles(edges: .all, length: length)
        return self.style(styles)
    }

    /// Rounds selected edges of this object by some value specified as a string.
    /// - Parameters:
    ///   - edges: Which corners should be rounded
    ///   - length: A string with rounding of your choosing, such as "50%"
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ edges: DiagonalEdge, _ length: LengthUnit) -> Self {
        let styles = CornerRadiusModifier.styles(edges: edges, length: length)
        return self.style(styles)
    }
}
