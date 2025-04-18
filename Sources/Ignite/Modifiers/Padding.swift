//
// Padding.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private enum PaddingType {
    case exact(LengthUnit), semantic(SpacingAmount)
}

@MainActor private func paddingModifier(
    _ padding: PaddingType,
    edges: Edge = .all,
    content: any HTML
) -> any HTML {
    switch padding {
    case .exact(let unit):
        let styles = content.edgeAdjustedStyles(prefix: "padding", edges, unit.stringValue)
        return content.style(styles)
    case .semantic(let amount):
        let classes = content.edgeAdjustedClasses(prefix: "p", edges, amount.rawValue)
        return content.class(classes)
    }
}

@MainActor private func paddingModifier(
    _ padding: PaddingType,
    edges: Edge = .all,
    content: any InlineElement
) -> any InlineElement {
    switch padding {
    case .exact(let unit):
        let styles = content.edgeAdjustedStyles(prefix: "padding", edges, unit.stringValue)
        return content.style(styles)
    case .semantic(let amount):
        let classes = content.edgeAdjustedClasses(prefix: "p", edges, amount.rawValue)
        return content.class(classes)
    }
}

public extension Element {
    /// Applies padding on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ length: Int = 20) -> some Element {
        AnyHTML(paddingModifier(.exact(.px(length)), content: self))
    }

    /// Applies padding on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ length: LengthUnit) -> some Element {
        AnyHTML(paddingModifier(.exact(length), content: self))
    }

    /// Applies padding on all sides of this element using adaptive sizing.
    /// - Parameter amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ amount: SpacingAmount) -> some Element {
        AnyHTML(paddingModifier(.semantic(amount), content: self))
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: Int = 20) -> some Element {
        AnyHTML(paddingModifier(.exact(.px(length)), edges: edges, content: self))
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: LengthUnit) -> some Element {
        AnyHTML(paddingModifier(.exact(length), edges: edges, content: self))
    }

    /// Applies padding on selected sides of this element using adaptive sizing.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ amount: SpacingAmount) -> some Element {
        AnyHTML(paddingModifier(.semantic(amount), edges: edges, content: self))
    }
}

public extension InlineElement {
    /// Applies padding on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ length: Int = 20) -> some InlineElement {
        AnyInlineElement(paddingModifier(.exact(.px(length)), content: self))
    }

    /// Applies padding on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ length: LengthUnit) -> some InlineElement {
        AnyInlineElement(paddingModifier(.exact(length), content: self))
    }

    /// Applies padding on all sides of this element using adaptive sizing.
    /// - Parameter amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ amount: SpacingAmount) -> some InlineElement {
        AnyInlineElement(paddingModifier(.semantic(amount), content: self))
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: Int = 20) -> some InlineElement {
        AnyInlineElement(paddingModifier(.exact(.px(length)), edges: edges, content: self))
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: LengthUnit) -> some InlineElement {
        AnyInlineElement(paddingModifier(.exact(length), edges: edges, content: self))
    }

    /// Applies padding on selected sides of this element using adaptive sizing.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ amount: SpacingAmount) -> some InlineElement {
        AnyInlineElement(paddingModifier(.semantic(amount), edges: edges, content: self))
    }
}

public extension DocumentElement {
    /// Applies padding on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ length: Int = 20) -> some DocumentElement {
        AnyHTML(paddingModifier(.exact(.px(length)), content: self))
    }

    /// Applies padding on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ length: LengthUnit) -> some DocumentElement {
        AnyHTML(paddingModifier(.exact(length), content: self))
    }

    /// Applies padding on all sides of this element using adaptive sizing.
    /// - Parameter amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ amount: SpacingAmount) -> some DocumentElement {
        AnyHTML(paddingModifier(.semantic(amount), content: self))
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: Int = 20) -> some DocumentElement {
        AnyHTML(paddingModifier(.exact(.px(length)), edges: edges, content: self))
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: LengthUnit) -> some DocumentElement {
        AnyHTML(paddingModifier(.exact(length), edges: edges, content: self))
    }

    /// Applies padding on selected sides of this element using adaptive sizing.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ amount: SpacingAmount) -> some DocumentElement {
        AnyHTML(paddingModifier(.semantic(amount), edges: edges, content: self))
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
