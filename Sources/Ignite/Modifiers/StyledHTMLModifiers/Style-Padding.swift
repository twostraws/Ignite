//
// Style-Padding.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension StyledHTML {
    /// Applies padding on selected sides of this element.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: Int) -> Self {
        let styles = edges.styles(prefix: "padding", length: "\(length)px")
        return self.style(styles)
    }

    /// Applies padding on selected sides of this element.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: LengthUnit) -> Self {
        let styles = edges.styles(prefix: "padding", length: length.stringValue)
        return self.style(styles)
    }
}
