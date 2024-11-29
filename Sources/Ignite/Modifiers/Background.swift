//
// Background.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A modifier that applies background styling to HTML elements.
struct BackgroundModifier: HTMLModifier {
    /// The color to apply, if using a direct color value.
    var color: Color?

    // The color to apply, if using a string value.
    var colorString: String?

    /// The style to apply, if using a registered style.
    var style: (any Style)?

    /// Applies the background style to the provided HTML content.
    /// - Parameter content: The HTML content to modify
    /// - Returns: The modified HTML content with background styling applied
    func body(content: some HTML) -> any HTML {
        if let color = getColor() {
            content.style("background-color: \(color)")
        } else if let style {
            let className = style.register()
            content.class(className)
        }
        content
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

extension HTML {
    /// Applies a background color from a `Color` object.
    /// - Parameter color: The specific color value to use, specified as
    /// a `Color` instance.
    /// - Returns: The current element with the updated background color.
    public func background(_ color: Color) -> some HTML {
        modifier(BackgroundModifier(color: color))
    }

    /// Applies a background color from a string.
    /// - Parameter color: The specific color value to use, specified as a string.
    /// - Returns: The current element with the updated background color.
    public func background(_ color: String) -> some HTML {
        modifier(BackgroundModifier(colorString: color))
    }

    /// Applies a background color from one or more `BackgroundStyle` cases.
    /// - Parameter style: The specific styles to use, specified as
    /// one or more `BackgroundStyle` instance. Specifying multiple
    /// gradients causes them to overlap, so you should blend them with opacity.
    /// - Returns: The current element with the updated background styles.
    func background(_ style: any Style) -> some HTML {
        modifier(BackgroundModifier(style: style))
    }
}

extension BlockHTML {
    /// Applies a background color from a `Color` object.
    /// - Parameter color: The specific color value to use, specified as
    /// a `Color` instance.
    /// - Returns: The current element with the updated background color.
    public func background(_ color: Color) -> some BlockHTML {
        modifier(BackgroundModifier(color: color))
    }

    /// Applies a background color from a string.
    /// - Parameter color: The specific color value to use, specified as a string.
    /// - Returns: The current element with the updated background color.
    public func background(_ color: String) -> some BlockHTML {
        modifier(BackgroundModifier(colorString: color))
    }

    /// Applies a background color from one or more `BackgroundStyle` cases.
    /// - Parameter style: The specific styles to use, specified as
    /// one or more `BackgroundStyle` instance. Specifying multiple
    /// gradients causes them to overlap, so you should blend them with opacity.
    /// - Returns: The current element with the updated background styles.
    func background(_ style: any Style) -> some BlockHTML {
        modifier(BackgroundModifier(style: style))
    }
}

extension HTML {
    /// Applies a background color from a string.
    /// - Parameter color: The specific color value to use, specified as a
    /// hex string such as "#FFE700".
    /// - Returns: The current element with the updated background color.
    @available(*, deprecated, renamed: "background(_:)")
    public func backgroundColor(_ color: String) -> Self {
        self.style("background-color: \(color)")
    }

    /// Applies a background color from a `Color` object.
    /// - Parameter color: The specific color value to use, specified as
    /// a `Color` instance.
    /// - Returns: The current element with the updated background color.
    @available(*, deprecated, renamed: "background(_:)")
    public func backgroundColor(_ color: Color) -> Self {
        self.style("background-color: \(color.description)")
    }
}
