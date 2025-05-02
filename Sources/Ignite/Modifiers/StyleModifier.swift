//
// StyleModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor private func styleModifier(
    _ style: any Style,
    content: any HTML
) -> any HTML {
    StyleManager.shared.registerStyle(style)
    return content.class(style.className)
}

@MainActor private func styleModifier(
    _ style: any Style,
    content: any InlineElement
) -> any InlineElement {
    StyleManager.shared.registerStyle(style)
    return content.class(style.className)
}

public extension HTML {
    /// Applies a custom style to the element.
    /// - Parameter style: The style to apply, conforming to the `Style` protocol
    /// - Returns: A modified copy of the element with the style applied
    func style(_ style: any Style) -> some HTML {
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
