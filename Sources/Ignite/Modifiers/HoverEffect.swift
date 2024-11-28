//
// HoverEffect.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A modifier that applies hover effects to HTML elements
struct HoverEffectModifier: HTMLModifier {
    /// The effect to apply when hovering
    private let effect: (EmptyHoverEffect) -> any HTML

    /// Creates a new hover effect modifier
    /// - Parameter effect: A closure that returns the effect to be applied
    init(_ effect: @escaping (EmptyHoverEffect) -> any HTML) {
        self.effect = effect
    }

    /// Applies hover effect to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with hover effect applied
    func body(content: some HTML) -> any HTML {
        content.onHover { isHovering in
            if isHovering {
                let effectElement = effect(EmptyHoverEffect())
                let effectAttributes = AttributeStore.default.attributes(for: effectElement.id)
                ApplyHoverEffects(styles: effectAttributes.styles)
            } else {
                RemoveHoverEffects()
            }
        }
    }
}

public extension HTML {
    /// Applies a hover effect to the page element
    /// - Parameter effect: A closure that returns the effect to be applied.
    ///   The argument acts as a placeholder representing this page element.
    /// - Returns: A modified copy of the element with hover effect applied
    func hoverEffect(_ effect: @escaping (EmptyHoverEffect) -> some HTML) -> some HTML {
        modifier(HoverEffectModifier(effect))
    }
}

/// An empty hover effect type to which styles can be added
public struct EmptyHoverEffect: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    public func render(context: PublishingContext) -> String { "" }
}

private struct ApplyHoverEffects: Action {
    let styles: OrderedSet<AttributeValue>

    func compile() -> String {
        """
        this.unhoveredStyle = this.style.cssText;
        \(styles.map { "this.style.\($0.name.convertingCSSNamesToJS()) = '\($0.value)'" }.joined(separator: "; "))
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
