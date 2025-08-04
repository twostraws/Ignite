//
// Style-Margin.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension StyledHTML {
    /// Applies margins on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - length: The amount of margin to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ length: LengthUnit) -> Self {
        let styles = edges.styles(prefix: "margin", length: length.stringValue)
        return self.style(styles)
    }
}
