//
// Padding.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension PageElement {
    /// Applies padding on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    public func padding(_ length: String = "20px") -> Self {
        edgeAdjust(prefix: "padding", .all, length)
    }

    /// Applies padding on all sides of this element, specified in pixels.
    /// - Parameter length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    public func padding(_ length: Int) -> Self {
        edgeAdjust(prefix: "padding", .all, "\(length)px")
    }

    /// Applies padding on all sides of this element using adaptive sizing.
    /// - Parameter amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    public func padding(_ amount: SpacingAmount) -> Self {
        edgeAdjust(prefix: "p", .all, amount)
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    public func padding(_ edges: Edge, _ length: String = "20px") -> Self {
        edgeAdjust(prefix: "padding", edges, length)
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    public func padding(_ edges: Edge, _ length: Int) -> Self {
        edgeAdjust(prefix: "padding", edges, "\(length)px")
    }

    /// Applies padding on selected sides of this element using adaptive sizing.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    public func padding(_ edges: Edge, _ amount: SpacingAmount) -> Self {
        edgeAdjust(prefix: "p", edges, amount)
    }
}
