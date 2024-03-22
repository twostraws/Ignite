//
// HorizontalAlignment.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Controls how elements are horizontally positioned in side their container.
public enum HorizontalAlignment: String {
    /// Elements are positioned at the start of their container.
    case leading = "text-start"

    /// Elements are positioned in the center of their container.
    case center = "text-center"

    /// Elements are positioned at the end of their container.
    case trailing = "text-end"
}

/// Determines which elements can have horizontal alignment attached,
public protocol HorizontalAligning: PageElement { }

extension HorizontalAligning {
    /// Aligns this element using the specific alignment.
    /// - Parameter alignment: How to align this element.
    /// - Returns: A copy of the current element with the updated
    /// horizontal alignment applied.
    public func horizontalAlignment(_ alignment: HorizontalAlignment) -> Self {
        self.class(alignment.rawValue)
    }
}
