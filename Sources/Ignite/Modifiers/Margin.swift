//
// Margin.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension PageElement {
    /// Applies margins on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of margin to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new margins applied.
    public func margin(_ length: String = "20px") -> Self {
        edgeAdjust(prefix: "margin", .all, length)
    }

    /// Applies margins on all sides of this element, specified in pixels.
    /// - Parameter length: The amount of margin to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new margins applied.
    public func margin(_ length: Int) -> Self {
        edgeAdjust(prefix: "margin", .all, "\(length)px")
    }

    /// Applies margins on all sides of this element using adaptive sizing.
    /// - Parameter amount: The amount of margin to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new margins applied.
    public func margin(_ amount: SpacingAmount) -> Self {
        edgeAdjust(prefix: "m", .all, amount)
    }

    /// Applies margins on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - length: The amount of margin to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new margins applied.
    public func margin(_ edges: Edge, _ length: String = "20px") -> Self {
        edgeAdjust(prefix: "margin", edges, length)
    }

    /// Applies margins on selected sides of this element, specified in pixels.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - length: The amount of margin to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new margins applied.
    public func margin(_ edges: Edge, _ length: Int) -> Self {
        edgeAdjust(prefix: "margin", edges, "\(length)px")
    }

    /// Applies margins on selected sides of this element, using adaptive sizing.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - amount: The amount of margin to apply, specified as a
    ///   `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new margins applied.
    public func margin(_ edges: Edge, _ amount: SpacingAmount) -> Self {
        edgeAdjust(prefix: "m", edges, amount)
    }
}
