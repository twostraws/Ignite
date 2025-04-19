//
// Margin.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private enum MarginType {
    case exact(LengthUnit), semantic(SpacingAmount)
}

@MainActor private func marginModifier(
    _ margin: MarginType,
    edges: Edge = .all,
    content: any BodyElement
) -> any BodyElement {
    switch margin {
    case .exact(let unit):
        let styles = content.edgeAdjustedStyles(prefix: "margin", edges, unit.stringValue)
        return content.style(styles)
    case .semantic(let amount):
        let classes = content.edgeAdjustedClasses(prefix: "m", edges, amount.rawValue)
        return content.class(classes)
    }
}

@MainActor private func marginModifier(
    _ margin: MarginType,
    edges: Edge = .all,
    content: any InlineElement
) -> any InlineElement {
    switch margin {
    case .exact(let unit):
        let styles = content.edgeAdjustedStyles(prefix: "margin", edges, unit.stringValue)
        return content.style(styles)
    case .semantic(let amount):
        let classes = content.edgeAdjustedClasses(prefix: "m", edges, amount.rawValue)
        return content.class(classes)
    }
}

public extension HTML {
    /// Applies margins on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of margin to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ length: Int = 20) -> some HTML {
        AnyHTML(marginModifier(.exact(.px(length)), content: self))
    }

    /// Applies margins on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of margin to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ length: LengthUnit) -> some HTML {
        AnyHTML(marginModifier(.exact(length), content: self))
    }

    /// Applies margins on all sides of this element using adaptive sizing.
    /// - Parameter amount: The amount of margin to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ amount: SpacingAmount) -> some HTML {
        AnyHTML(marginModifier(.semantic(amount), content: self))
    }

    /// Applies margins on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - length: The amount of margin to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ length: Int = 20) -> some HTML {
        AnyHTML(marginModifier(.exact(.px(length)), edges: edges, content: self))
    }

    /// Applies margins on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - length: The amount of margin to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ length: LengthUnit) -> some HTML {
        AnyHTML(marginModifier(.exact(length), edges: edges, content: self))
    }

    /// Applies margins on selected sides of this element, using adaptive sizing.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - amount: The amount of margin to apply, specified as a
    ///   `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ amount: SpacingAmount) -> some HTML {
        AnyHTML(marginModifier(.semantic(amount), edges: edges, content: self))
    }
}

public extension InlineElement {
    /// Applies margins on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of margin to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ length: Int = 20) -> some InlineElement {
        AnyInlineElement(marginModifier(.exact(.px(length)), content: self))
    }

    /// Applies margins on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of margin to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ length: LengthUnit) -> some InlineElement {
        AnyInlineElement(marginModifier(.exact(length), content: self))
    }

    /// Applies margins on all sides of this element using adaptive sizing.
    /// - Parameter amount: The amount of margin to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ amount: SpacingAmount) -> some InlineElement {
        AnyInlineElement(marginModifier(.semantic(amount), content: self))
    }

    /// Applies margins on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - length: The amount of margin to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ length: Int = 20) -> some InlineElement {
        AnyInlineElement(marginModifier(.exact(.px(length)), edges: edges, content: self))
    }

    /// Applies margins on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - length: The amount of margin to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ length: LengthUnit) -> some InlineElement {
        AnyInlineElement(marginModifier(.exact(length), edges: edges, content: self))
    }

    /// Applies margins on selected sides of this element, using adaptive sizing.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - amount: The amount of margin to apply, specified as a
    ///   `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ amount: SpacingAmount) -> some InlineElement {
        AnyInlineElement(marginModifier(.semantic(amount), edges: edges, content: self))
    }
}

public extension StyledHTML {
    /// Applies margins on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - length: The amount of margin to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ length: LengthUnit = .px(20)) -> Self {
        let styles = self.edgeAdjustedStyles(prefix: "margin", edges, length.stringValue)
        return self.style(styles)
    }
}
