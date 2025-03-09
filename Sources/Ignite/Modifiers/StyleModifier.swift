//
// StyleModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Applies a custom style to the element.
    /// - Parameter style: The style to apply, conforming to the `Style` protocol
    /// - Returns: A modified copy of the element with the style applied
    func style(_ style: any Style) -> some HTML {
        AnyHTML(styleModifier(style))
    }
}

public extension InlineElement {
    /// Applies a custom style to the block element.
    /// - Parameter style: The style to apply, conforming to the `Style` protocol
    /// - Returns: A modified copy of the block element with the style applied
    func style(_ style: any Style) -> some InlineElement {
        AnyHTML(styleModifier(style))
    }
}

private extension HTML {
    func styleModifier(_ style: any Style) -> any HTML {
        let className = StyleManager.shared.className(for: style)
        StyleManager.shared.registerStyle(style)
        return self.class(className)
    }
}
