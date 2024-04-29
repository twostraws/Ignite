//
// Hidden.swift
// IgniteSamples
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension PageElement {
    /// Optionally hides the view in the view hierarchy.
    /// - Parameter isHidden: Whether to hide this element or not.
    /// - Returns: A copy of the current element, optionally hidden.
    public func hidden(_ isHidden: Bool = true) -> Self {
        self
            .class(isHidden ? "d-none" : nil)
    }
}
