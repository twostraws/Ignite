//
// StyleModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor private func styleModifier(
    _ style: any Style,
    content: any Element
) -> any Element {
    let className = StyleManager.shared.className(for: style)
    StyleManager.shared.registerStyle(style)
    return content.class(className)
}

@MainActor private func styleModifier(
    _ style: any Style,
    content: any InlineElement
) -> any InlineElement {
    let className = StyleManager.shared.className(for: style)
    StyleManager.shared.registerStyle(style)
    return content.class(className)
}

public extension Element {
    /// Applies a custom style to the element.
    /// - Parameter style: The style to apply, conforming to the `Style` protocol
    /// - Returns: A modified copy of the element with the style applied
    func style(_ style: any Style) -> some Element {
        AnyHTML(styleModifier(style, content: self))
    }
}

public extension InlineElement {
    /// Applies a custom style to the element.
    /// - Parameter style: The style to apply, conforming to the `Style` protocol
    /// - Returns: A modified copy of the element with the style applied
    func style(_ style: any Style) -> some InlineElement {
        AnyInlineElement(styleModifier(style, content: self))
    }
}
