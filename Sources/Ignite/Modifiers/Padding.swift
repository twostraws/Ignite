//
// Padding.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

struct PaddingModifier: HTMLModifier {
    var length: (any LengthUnit)?
    var amount: SpacingAmount?
    var edges = Edge.all
    
    func body(content: some HTML) -> any HTML {
        if let length {
            content.edgeAdjust(prefix: "padding", edges, length.stringValue)
        } else if let amount {
            content.edgeAdjust(prefix: "p", edges, amount)
        }
        content
    }
}

public extension HTML {
    /// Applies padding on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ length: String = "20px") -> some HTML {
        modifier(PaddingModifier(length: length))
    }

    /// Applies padding on all sides of this element, specified in pixels.
    /// - Parameter length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ length: Int) -> some HTML {
        modifier(PaddingModifier(length: length))
    }

    /// Applies padding on all sides of this element using adaptive sizing.
    /// - Parameter amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ amount: SpacingAmount) -> some HTML {
        modifier(PaddingModifier(amount: amount))
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: String = "20px") -> some HTML {
        modifier(PaddingModifier(length: length, edges: edges))
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: Int) -> some HTML {
        modifier(PaddingModifier(length: length, edges: edges))
    }

    /// Applies padding on selected sides of this element using adaptive sizing.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ amount: SpacingAmount) -> some HTML {
        modifier(PaddingModifier(amount: amount, edges: edges))
    }
}

public extension RootHTML {
    /// Applies padding on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ length: String = "20px") -> some RootHTML {
        modifier(PaddingModifier(length: length))
    }

    /// Applies padding on all sides of this element, specified in pixels.
    /// - Parameter length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ length: Int) -> some HTML {
        modifier(PaddingModifier(length: length))
    }

    /// Applies padding on all sides of this element using adaptive sizing.
    /// - Parameter amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ amount: SpacingAmount) -> some RootHTML {
        modifier(PaddingModifier(amount: amount))
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: String = "20px") -> some RootHTML {
        modifier(PaddingModifier(length: length, edges: edges))
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: Int) -> some RootHTML {
        modifier(PaddingModifier(length: length, edges: edges))
    }

    /// Applies padding on selected sides of this element using adaptive sizing.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ amount: SpacingAmount) -> some RootHTML {
        modifier(PaddingModifier(amount: amount, edges: edges))
    }
}
