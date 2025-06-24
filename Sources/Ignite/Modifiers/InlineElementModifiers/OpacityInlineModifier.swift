//
// OpacityInlineModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies opacity styling to inline HTML elements.
private struct OpacityInlineModifier: InlineElementModifier {
    /// The opacity value to apply.
    var opacity: OpacityType

    func body(content: Content) -> some InlineElement {
        var modified = content
        let styles = OpacityModifier.styles(for: opacity)
        modified.attributes.append(styles: styles)
        return modified
    }
}

public extension InlineElement {
    /// Adjusts the opacity of an element.
    /// - Parameter value: A value between 0% (fully transparent) and 100% (fully opaque).
    /// - Returns: A modified copy of the element with opacity applied
    func opacity(_ value: Percentage) -> some InlineElement {
        modifier(OpacityInlineModifier(opacity: .percent(value)))
    }

    /// Adjusts the opacity of an element.
    /// - Parameter value: A value between 0 (fully transparent) and 1.0 (fully opaque).
    /// - Returns: A modified copy of the element with opacity applied
    func opacity(_ value: Double) -> some InlineElement {
        modifier(OpacityInlineModifier(opacity: .double(value)))
    }
}
