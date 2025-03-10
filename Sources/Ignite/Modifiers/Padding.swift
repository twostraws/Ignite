//
// Padding.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Applies padding on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ length: Int = 20) -> some HTML {
        AnyHTML(paddingModifier(.exact(.px(length))))
    }

    /// Applies padding on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ length: LengthUnit) -> some HTML {
        AnyHTML(paddingModifier(.exact(length)))
    }

    /// Applies padding on all sides of this element using adaptive sizing.
    /// - Parameter amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ amount: SpacingAmount) -> some HTML {
        AnyHTML(paddingModifier(.semantic(amount)))
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: Int = 20) -> some HTML {
        AnyHTML(paddingModifier(.exact(.px(length)), edges: edges))
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: LengthUnit) -> some HTML {
        AnyHTML(paddingModifier(.exact(length), edges: edges))
    }

    /// Applies padding on selected sides of this element using adaptive sizing.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ amount: SpacingAmount) -> some HTML {
        AnyHTML(paddingModifier(.semantic(amount), edges: edges))
    }
}

public extension DocumentElement {
    /// Applies padding on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ length: Int = 20) -> some DocumentElement {
        AnyHTML(paddingModifier(.exact(.px(length))))
    }

    /// Applies padding on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ length: LengthUnit) -> some DocumentElement {
        AnyHTML(paddingModifier(.exact(length)))
    }

    /// Applies padding on all sides of this element using adaptive sizing.
    /// - Parameter amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ amount: SpacingAmount) -> some DocumentElement {
        AnyHTML(paddingModifier(.semantic(amount)))
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: Int = 20) -> some DocumentElement {
        AnyHTML(paddingModifier(.exact(.px(length)), edges: edges))
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: LengthUnit) -> some DocumentElement {
        AnyHTML(paddingModifier(.exact(length), edges: edges))
    }

    /// Applies padding on selected sides of this element using adaptive sizing.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ amount: SpacingAmount) -> some DocumentElement {
        AnyHTML(paddingModifier(.semantic(amount), edges: edges))
    }
}

public extension StyledHTML {
    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: LengthUnit) -> Self {
        let styles = self.edgeAdjustedStyles(prefix: "padding", edges, length.stringValue)
        return self.style(styles)
    }
}

enum PaddingType {
    case exact(LengthUnit), semantic(SpacingAmount)
}

private extension HTML {
    func paddingModifier(_ padding: PaddingType, edges: Edge = .all) -> any HTML {
        switch padding {
        case .exact(let unit):
            let styles = self.edgeAdjustedStyles(prefix: "padding", edges, unit.stringValue)
            return self.style(styles)
        case .semantic(let amount):
            return self.edgeAdjust(prefix: "p", edges, amount)
        }
    }
}
