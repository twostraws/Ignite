//
// Hidden.swift
// IgniteSamples
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public extension HTML {
    /// Optionally hides the view in the view hierarchy.
    /// - Parameter isHidden: Whether to hide this element or not.
    /// - Returns: A copy of the current element, optionally hidden.
    func hidden(_ isHidden: Bool = true) -> Self {
        self
            .class(isHidden ? "d-none" : nil)
    }
}
