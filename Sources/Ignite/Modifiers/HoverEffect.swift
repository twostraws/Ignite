//
// HoverEffect.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Applies a hover effect to the page element
    /// - Parameter effect: A closure that returns the effect to be applied.
    ///   The argument acts as a placeholder representing this page element.
    /// - Returns: A modified copy of the element with hover effect applied
    func hoverEffect(_ effect: @escaping (EmptyHTMLHoverEffect) -> some HTML) -> some HTML {
        self.hoverEffectModifier(effect)
    }
}

private extension HTML {
    // An abstraction of the implementation details for consistent reuse across protocol extensions.
    func hoverEffectModifier(
        _ effect: @escaping (EmptyHTMLHoverEffect) -> some HTML
    ) -> some HTML {
        self.onHover { isHovering in
            if isHovering {
                let effectElement = effect(EmptyHTMLHoverEffect())
                let effectAttributes = effectElement.attributes
                ApplyHoverEffects(styles: effectAttributes.styles)
            } else {
                RemoveHoverEffects()
            }
        }
    }
}

/// An empty hover effect type to which styles can be added
public struct EmptyHTMLHoverEffect: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    public func markup() -> Markup { Markup() }
}

public extension InlineElement {
    /// Applies a hover effect to the inline element
    /// - Parameter effect: A closure that returns the effect to be applied.
    ///   The argument acts as a placeholder representing this inline element.
    /// - Returns: A modified copy of the element with hover effect applied
    func hoverEffect(_ effect: @escaping (EmptyInlineElementHoverEffect) -> some InlineElement) -> some InlineElement {
        self.hoverEffectModifier(effect)
    }
}

private extension InlineElement {
    // An abstraction of the implementation details for consistent reuse across protocol extensions.
    func hoverEffectModifier(
        _ effect: @escaping (EmptyInlineElementHoverEffect) -> some InlineElement
    ) -> some InlineElement {
        self.onHover { isHovering in
            if isHovering {
                let effectElement = effect(EmptyInlineElementHoverEffect())
                let effectAttributes = effectElement.attributes
                ApplyHoverEffects(styles: effectAttributes.styles)
            } else {
                RemoveHoverEffects()
            }
        }
    }
}

/// An empty hover effect type to which styles can be added
public struct EmptyInlineElementHoverEffect: InlineElement {
    /// The content and behavior of this element.
    public var body: some InlineElement { self }

    public func markup() -> Markup { Markup() }
}

private struct ApplyHoverEffects: Action {
    let styles: OrderedSet<InlineStyle>

    func compile() -> String {
        """
        this.unhoveredStyle = this.style.cssText;
        \(self.styles.map {
            "this.style.\($0.property.convertingCSSNamesToJS()) = '\($0.value)'"
        }.joined(separator: "; "))
        """
    }
}

private struct RemoveHoverEffects: Action {
    func compile() -> String {
        """
        this.style.cssText = this.unhoveredStyle;
        """
    }
}
