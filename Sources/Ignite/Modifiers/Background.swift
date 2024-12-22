//
// Background.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies background styling to HTML elements.
struct BackgroundModifier: HTMLModifier {
    /// The color to apply, if using a direct color value.
    var color: Color?

    // The color to apply, if using a string value.
    var colorString: String?

    // The material to apply.
    var material: Material?

    /// Applies the background style to the provided HTML content.
    /// - Parameter content: The HTML content to modify
    /// - Returns: The modified HTML content with background styling applied
    func body(content: some HTML) -> any HTML {
        if let color = getColor() {
            content.style("background-color: \(color)")
        } else if let material {
            content.class(material.className)
        }
    }

    private func getColor() -> String? {
        if let color {
            color.description
        } else if let colorString {
            colorString
        } else {
            nil
        }
    }
}

public extension HTML {
    /// Applies a background color from a `Color` object.
    /// - Parameter color: The specific color value to use, specified as
    /// a `Color` instance.
    /// - Returns: The current element with the updated background color.
    func background(_ color: Color) -> some HTML {
        modifier(BackgroundModifier(color: color))
    }

    /// Applies a background color from a string.
    /// - Parameter color: The specific color value to use, specified as a string.
    /// - Returns: The current element with the updated background color.
    func background(_ color: String) -> some HTML {
        modifier(BackgroundModifier(colorString: color))
    }

    /// Applies a material effect background
    /// - Parameter material: The type of material to apply
    /// - Returns: The modified HTML element
    func background(_ material: Material) -> some HTML {
        modifier(BackgroundModifier(material: material))
    }
}

public extension BlockHTML {
    /// Applies a background color from a `Color` object.
    /// - Parameter color: The specific color value to use, specified as
    /// a `Color` instance.
    /// - Returns: The current element with the updated background color.
    func background(_ color: Color) -> some BlockHTML {
        modifier(BackgroundModifier(color: color))
    }

    /// Applies a background color from a string.
    /// - Parameter color: The specific color value to use, specified as a string.
    /// - Returns: The current element with the updated background color.
    func background(_ color: String) -> some BlockHTML {
        modifier(BackgroundModifier(colorString: color))
    }

    /// Applies a material effect background.
    /// - Parameter material: The type of material to apply.
    /// - Returns: The current element with the updated background material.
    func background(_ material: Material) -> some BlockHTML {
        modifier(BackgroundModifier(material: material))
    }
}
