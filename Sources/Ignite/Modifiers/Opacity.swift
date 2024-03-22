//
// Opacity.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension PageElement {
    /// Adjusts the opacity of an element.
    /// - Parameter value: A value between 0 (fully transparent) and 1 (fully opaque).
    /// - Returns: A copy of the current element with the updated opacity.
    public func opacity(_ value: Double) -> Self {
        if value != 1 {
            self.style("opacity: \(value.formatted())")
        } else {
            self
        }
    }
}
