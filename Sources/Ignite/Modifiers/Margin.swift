//
// Margin.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

struct MarginModifier: HTMLModifier {
    var length: (any LengthUnit)?
    var amount: SpacingAmount?
    var edges = Edge.all
    
    func body(content: some HTML) -> any HTML {
        if let length {
            content.edgeAdjust(prefix: "margin", edges, length.stringValue)
        } else if let amount {
            content.edgeAdjust(prefix: "m", edges, amount)
        }
        content
    }
}

public extension HTML {
    /// Applies margins on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of margin to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ length: String = "20px") -> some HTML {
        modifier(MarginModifier(length: length))
    }

    /// Applies margins on all sides of this element, specified in pixels.
    /// - Parameter length: The amount of margin to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ length: Int) -> some HTML {
        modifier(MarginModifier(length: length))
    }

    /// Applies margins on all sides of this element using adaptive sizing.
    /// - Parameter amount: The amount of margin to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ amount: SpacingAmount) -> some HTML {
        modifier(MarginModifier(amount: amount))
    }

    /// Applies margins on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - length: The amount of margin to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ length: String = "20px") -> some HTML {
        modifier(MarginModifier(length: length, edges: edges))
    }

    /// Applies margins on selected sides of this element, specified in pixels.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - length: The amount of margin to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ length: Int) -> some HTML {
        modifier(MarginModifier(length: length, edges: edges))
    }

    /// Applies margins on selected sides of this element, using adaptive sizing.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - amount: The amount of margin to apply, specified as a
    ///   `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ amount: SpacingAmount) -> some HTML {
        modifier(MarginModifier(amount: amount, edges: edges))
    }
}

public extension InlineHTML {
    /// Applies margins on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of margin to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ length: String = "20px") -> some InlineHTML {
        modifier(MarginModifier(length: length))
    }

    /// Applies margins on all sides of this element, specified in pixels.
    /// - Parameter length: The amount of margin to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ length: Int) -> some InlineHTML {
        modifier(MarginModifier(length: length))
    }

    /// Applies margins on all sides of this element using adaptive sizing.
    /// - Parameter amount: The amount of margin to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ amount: SpacingAmount) -> some InlineHTML {
        modifier(MarginModifier(amount: amount))
    }

    /// Applies margins on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - length: The amount of margin to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ length: String = "20px") -> some InlineHTML {
        modifier(MarginModifier(length: length, edges: edges))
    }

    /// Applies margins on selected sides of this element, specified in pixels.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - length: The amount of margin to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ length: Int) -> some InlineHTML {
        modifier(MarginModifier(length: length, edges: edges))
    }

    /// Applies margins on selected sides of this element, using adaptive sizing.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - amount: The amount of margin to apply, specified as a
    ///   `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ amount: SpacingAmount) -> some InlineHTML {
        modifier(MarginModifier(amount: amount, edges: edges))
    }
}
