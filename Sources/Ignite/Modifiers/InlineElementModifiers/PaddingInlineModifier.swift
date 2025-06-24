//
// PaddingInlineModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies padding to inline elements.
private struct PaddingInlineModifier: InlineElementModifier {
    /// The amount of padding to apply.
    var padding: PaddingAmount
    /// The edges where padding should be applied.
    var edges: Edge

    func body(content: Content) -> some InlineElement {
        var modified = content

        switch padding {
        case .exact(let unit):
            let styles = edges.styles(prefix: "padding", length: unit.stringValue)
            modified.attributes.append(styles: styles)
        case .semantic(let amount):
            let classes = edges.classes(prefix: "p", amount: amount.rawValue)
            modified.attributes.append(classes: classes)
        default: break
        }

        return modified
    }
}

public extension InlineElement {
    /// Applies padding on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ length: Int = 20) -> some InlineElement {
        modifier(PaddingInlineModifier(padding: .exact((.px(length))), edges: .all))
    }

    /// Applies padding on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ length: LengthUnit) -> some InlineElement {
        modifier(PaddingInlineModifier(padding: .exact(length), edges: .all))
    }

    /// Applies padding on all sides of this element using adaptive sizing.
    /// - Parameter amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ amount: SemanticSpacing) -> some InlineElement {
        modifier(PaddingInlineModifier(padding: .semantic(amount), edges: .all))
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: Int = 20) -> some InlineElement {
        modifier(PaddingInlineModifier(padding: .exact((.px(length))), edges: edges))
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: LengthUnit) -> some InlineElement {
        modifier(PaddingInlineModifier(padding: .exact(length), edges: edges))
    }

    /// Applies padding on selected sides of this element using adaptive sizing.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ amount: SemanticSpacing) -> some InlineElement {
        modifier(PaddingInlineModifier(padding: .semantic(amount), edges: edges))
    }
}
