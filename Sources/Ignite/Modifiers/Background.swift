//
// Background.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies background styling to HTML elements.
struct BackgroundModifier: HTMLModifier {
    /// The type of background to apply
    enum BackgroundType {
        case color(Color)
        case colorString(String)
        case material(Material)
        case gradient(Gradient)
    }

    /// The background configuration to apply
    let background: BackgroundType

    /// Applies the background style to the provided HTML content.
    /// - Parameter content: The HTML content to modify
    /// - Returns: The modified HTML content with background styling applied
    func body(content: some HTML) -> any HTML {
        switch background {
        case .gradient(let gradient):
            content.style(.backgroundImage, gradient.description)
        case .color(let color):
            content.style(.backgroundColor, color.description)
        case .colorString(let colorString):
            content.style(.backgroundColor, colorString)
        case .material(let material):
            content.class(material.className)
        }
    }
}

public extension HTML {
    /// Applies a background color from a `Color` object.
    /// - Parameter color: The specific color value to use, specified as
    /// a `Color` instance.
    /// - Returns: The current element with the updated background color.
    func background(_ color: Color) -> some HTML {
        modifier(BackgroundModifier(background: .color(color)))
    }

    /// Applies a background color from a string.
    /// - Parameter color: The specific color value to use, specified as a string.
    /// - Returns: The current element with the updated background color.
    func background(_ color: String) -> some HTML {
        modifier(BackgroundModifier(background: .colorString(color)))
    }

    /// Applies a material effect background
    /// - Parameter material: The type of material to apply
    /// - Returns: The modified HTML element
    func background(_ material: Material) -> some HTML {
        modifier(BackgroundModifier(background: .material(material)))
    }

    /// Applies a gradient background
    /// - Parameter gradient: The gradient to apply
    /// - Returns: The modified HTML element
    func background(_ gradient: Gradient) -> some HTML {
        modifier(BackgroundModifier(background: .gradient(gradient)))
    }
}

public extension BlockHTML {
    /// Applies a background color from a `Color` object.
    /// - Parameter color: The specific color value to use, specified as
    /// a `Color` instance.
    /// - Returns: The current element with the updated background color.
    func background(_ color: Color) -> some BlockHTML {
        modifier(BackgroundModifier(background: .color(color)))
    }

    /// Applies a background color from a string.
    /// - Parameter color: The specific color value to use, specified as a string.
    /// - Returns: The current element with the updated background color.
    func background(_ color: String) -> some BlockHTML {
        modifier(BackgroundModifier(background: .colorString(color)))
    }

    /// Applies a material effect background.
    /// - Parameter material: The type of material to apply.
    /// - Returns: The current element with the updated background material.
    func background(_ material: Material) -> some BlockHTML {
        modifier(BackgroundModifier(background: .material(material)))
    }

    /// Applies a gradient background
    /// - Parameter gradient: The gradient to apply
    /// - Returns: The modified HTML element
    func background(_ gradient: Gradient) -> some BlockHTML {
        modifier(BackgroundModifier(background: .gradient(gradient)))
    }
}
