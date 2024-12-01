//
// HoverEffect.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public extension HTML {
    /// Applies a hover effect to the page element
    /// - Parameter effect: A closure that returns the effect to be applied.
    ///   The argument acts as a placeholder representing this page element.
    /// - Returns: The page element with the provided hover effect applied.
    @discardableResult
    func hoverEffect(_ effect: @escaping (EmptyHoverEffect) -> some HTML) -> Self {
        onHover { isHovering in
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
