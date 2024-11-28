//
// ForegroundStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Common foreground styles that allow for clear readability.
public enum ForegroundStyle: String {
    case primary = "text-primary"
    case primaryEmphasis = "text-primary-emphasis"
    case secondary = "text-body-secondary"
    case tertiary = "text-body-tertiary"

    case success = "text-success"
    case successEmphasis = "text-success-emphasis"
    case danger = "text-danger"
    case dangerEmphasis = "text-danger-emphasis"
    case warning = "text-warning"
    case warningEmphasis = "text-warning-emphasis"
    case info = "text-info"
    case infoEmphasis = "text-info-emphasis"
    case light = "text-light"
    case lightEmphasis = "text-light-emphasis"
    case dark = "text-dark"
    case darkEmphasis = "text-dark-emphasis"
    case body = "text-body"
    case bodyEmphasis = "text-body-emphasis"
}

/// A modifier that applies foreground color styling to HTML elements, handling both primitive and composite content.
struct ForegroundStyleModifier: HTMLModifier {
    /// The style to apply, if using a registered style.
    var colorString: String? = nil

    /// The color to apply, if using a direct color value.
    var color: Color? = nil

    /// Applies the foreground style to the provided HTML content.
    /// - Parameter content: The HTML content to modify
    /// - Returns: The modified HTML content with foreground styling applied
    func body(content: some HTML) -> any HTML {
        if let color = getColor() {
            if content.body.isComposite {
                content
                    .addContainerStyle(.init(name: "color", value: color))
                    .class("color-inherit")
            } else {
                content.style("color: \(color)")
            }
        }
        content
    }

    private func getColor() -> String? {
        if let colorString {
            colorString
        } else if let color {
            color.description
        } else {
            nil
        }
    }
}

extension HTML {
    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    public func foregroundStyle(_ color: Color) -> some HTML {
        modifier(ForegroundStyleModifier(color: color))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a string.
    /// - Returns: The current element with the updated color applied.
    public func foregroundStyle(_ color: String) -> some HTML {
        modifier(ForegroundStyleModifier(colorString: color))
    }
}

extension HTML where Self == Image {
    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    public func foregroundStyle(_ color: Color) -> some InlineHTML {
        modifier(ForegroundStyleModifier(color: color))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a string.
    /// - Returns: The current element with the updated color applied.
    public func foregroundStyle(_ color: String) -> some InlineHTML {
        modifier(ForegroundStyleModifier(colorString: color))
    }
}
