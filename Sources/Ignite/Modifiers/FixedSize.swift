//
// FixedSize.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension Element {
    /// Forces an element to be sized based on its content rather than expanding to fill its container.
    /// - Returns: A modified copy of the element with fixed sizing applied
    func fixedSize() -> some Element {
        Section(self)
            .style(.display, "inline-block")
    }
}
