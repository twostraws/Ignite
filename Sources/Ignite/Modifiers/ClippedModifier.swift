//
// Clipped.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Applies CSS overflow:hidden to clip the element's content to its bounds.
    /// - Returns: A modified copy of the element with clipping applied
    func clipped() -> some HTML {
        self.style(.overflow, "hidden")
    }
}
