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
    
    /// The style to apply, if using a registered style.
//    var style: (any Style)?
    
    /// Applies the background style to the provided HTML content.
    /// - Parameter content: The HTML content to modify
    /// - Returns: The modified HTML content with background styling applied
    func body(content: some HTML) -> any HTML {
        if let color {
            content.style("background-color: \(color.description)")
        }
//        else if let style {
//            let className = style.register()
//            content.class(className)
//        }
        content
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
    
    /// Applies a background color from one or more `BackgroundStyle` cases.
    /// - Parameter style: The specific styles to use, specified as
    /// one or more `BackgroundStyle` instance. Specifying multiple
    /// gradients causes them to overlap, so you should blend them with opacity.
    /// - Returns: The current element with the updated background styles.
//    func background<T: Style>(_ style: T) -> some HTML {
//        modifier(BackgroundModifier(style: style))
//    }
}

public extension BlockHTML {
    /// Applies a background color from a `Color` object.
    /// - Parameter color: The specific color value to use, specified as
    /// a `Color` instance.
    /// - Returns: The current element with the updated background color.
    func background(_ color: Color) -> some BlockHTML {
        modifier(BackgroundModifier(color: color))
    }
    
    /// Applies a background color from one or more `BackgroundStyle` cases.
    /// - Parameter style: The specific styles to use, specified as
    /// one or more `BackgroundStyle` instance. Specifying multiple
    /// gradients causes them to overlap, so you should blend them with opacity.
    /// - Returns: The current element with the updated background styles.
//    func background<T: Style>(_ style: T) -> some BlockHTML {
//        modifier(BackgroundModifier(style: style))
//    }
}
