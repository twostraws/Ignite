//
// Background.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Applies a background color from a `Color` object.
    /// - Parameter color: The specific color value to use, specified as
    /// a `Color` instance.
    /// - Returns: The current element with the updated background color.
    func background(_ color: Color) -> some HTML {
        self.style(.backgroundColor, color.description)
    }

    /// Applies a background color from a string.
    /// - Parameter color: The specific color value to use, specified as a string.
    /// - Returns: The current element with the updated background color.
    func background(_ color: String) -> some HTML {
        self.style(.backgroundColor, color)
    }

    /// Applies a material effect background
    /// - Parameter material: The type of material to apply
    /// - Returns: The modified HTML element
    func background(_ material: Material) -> some HTML {
        self.class(material.className)
    }

    /// Applies a gradient background
    /// - Parameter gradient: The gradient to apply
    /// - Returns: The modified HTML element
    func background(_ gradient: Gradient) -> some HTML {
        self.style(.backgroundImage, gradient.description)
    }
}

public extension InlineElement {
    /// Applies a background color from a `Color` object.
    /// - Parameter color: The specific color value to use, specified as
    /// a `Color` instance.
    /// - Returns: The current element with the updated background color.
    func background(_ color: Color) -> some InlineElement {
        self.style(.backgroundColor, color.description)
    }

    /// Applies a background color from a string.
    /// - Parameter color: The specific color value to use, specified as a string.
    /// - Returns: The current element with the updated background color.
    func background(_ color: String) -> some InlineElement {
        self.style(.backgroundColor, color)
    }

    /// Applies a material effect background
    /// - Parameter material: The type of material to apply
    /// - Returns: The modified HTML element
    func background(_ material: Material) -> some InlineElement {
        self.class(material.className)
    }

    /// Applies a gradient background
    /// - Parameter gradient: The gradient to apply
    /// - Returns: The modified HTML element
    func background(_ gradient: Gradient) -> some InlineElement {
        self.style(.backgroundImage, gradient.description)
    }
}

public extension StyledHTML {
    /// Applies a background color from a `Color` object.
    /// - Parameter color: The specific color value to use, specified as
    /// a `Color` instance.
    /// - Returns: The current element with the updated background color.
    func background(_ color: Color) -> Self {
        self.style(.backgroundColor, color.description)
    }

    /// Applies a gradient background
    /// - Parameter gradient: The gradient to apply
    /// - Returns: The modified HTML element
    func background(_ gradient: Gradient) -> Self {
        self.style(.backgroundImage, gradient.description)
    }
}
