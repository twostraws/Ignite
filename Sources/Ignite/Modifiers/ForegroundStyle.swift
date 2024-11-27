//
// ForegroundStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A modifier that applies foreground color styling to HTML elements, handling both primitive and composite content.
struct ForegroundStyleModifier: HTMLModifier {
    /// The style to apply, if using a registered style.
//    var style: (any Style)? = nil
    
    /// The color to apply, if using a direct color value.
    var color: Color? = nil
    
    /// Applies the foreground style to the provided HTML content.
    /// - Parameter content: The HTML content to modify
    /// - Returns: The modified HTML content with foreground styling applied
    func body(content: some HTML) -> any HTML {
//        if let style {
//            if content.body.isComposite {
//                let className = style.register()
//                // Add a wrapper div to storage and apply the style class to it
//                content.addContainerClass(className!)
//                    .class("color-inherit")
//            } else {
//                let className = style.register()
//                content.class(className)
//            }
//        } else
        if let color {
            if content.body.isComposite {
                content
                    .addContainerStyle(.init(name: "color", value: color.description))
                    .class("color-inherit")
            } else {
                content.style("color: \(color)")
            }
        }
        content
    }
}

public extension HTML {
    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a string.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: Color) -> some HTML {
        modifier(ForegroundStyleModifier(color: color))
    }
    
//    /// Applies a foreground style to the current element.
//    /// - Parameter style: The style to apply
//    /// - Returns: The element with the updated style applied.
//    func foregroundStyle(_ style: any Style) -> some HTML {
//        modifier(ForegroundStyleModifier(style: style))
//    }
}

public extension HTML where Self == Image {
    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a string.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: Color) -> some InlineHTML {
        modifier(ForegroundStyleModifier(color: color))
    }
}
