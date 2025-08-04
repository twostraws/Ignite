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
        StyleManager.shared.registerStyle(style)
        return self.class(style.className)
    }
}

public extension InlineElement {
    /// Applies a custom style to the element.
    /// - Parameter style: The style to apply, conforming to the `Style` protocol
    /// - Returns: A modified copy of the element with the style applied
    func style(_ style: any Style) -> some InlineElement {
        StyleManager.shared.registerStyle(style)
        return self.class(style.className)
    }
}
