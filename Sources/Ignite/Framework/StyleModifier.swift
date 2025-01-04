//
// ForegroundStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct StyleModifier: HTMLModifier {
    /// The style to apply.
    let style: any Style

    /// Applies the background style to the provided HTML content.
    /// - Parameter content: The HTML content to modify
    /// - Returns: The modified HTML content with background styling applied
    func body(content: some HTML) -> any HTML {
        let className = StyleManager.default.className(for: style)
        StyleManager.default.registerStyle(style)
        return content.class(className)
    }
}

public extension HTML {
    /// Applies a custom style to the element.
    /// - Parameter style: The style to apply, conforming to the `Style` protocol
    /// - Returns: A modified copy of the element with the style applied
    func style(_ style: any Style) -> some HTML {
        modifier(StyleModifier(style: style))
    }
}

public extension BlockHTML {
    /// Applies a custom style to the block element.
    /// - Parameter style: The style to apply, conforming to the `Style` protocol
    /// - Returns: A modified copy of the block element with the style applied
    func style(_ style: any Style) -> some BlockHTML {
        modifier(StyleModifier(style: style))
    }
}
