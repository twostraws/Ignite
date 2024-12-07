//
// ForegroundStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

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

    /// The style to apply, if using a registered style.
    var style: (any Style)? = nil

    /// Applies the foreground style to the provided HTML content.
    /// - Parameter content: The HTML content to modify
    /// - Returns: The modified HTML content with foreground styling applied
    func body(content: some HTML) -> any HTML {
        if let style {
            if content.body.isComposite {
                let className = style.register()
                // Add a wrapper div to storage and apply the style class to it
                content.containerClass(className!)
                    .class("color-inherit")
            } else {
                let className = style.register()
                content.class(className)
            }
        } else if let color = getColor() {
            if content.body.isComposite {
                content
                    .containerStyle(.init(name: "color", value: color))
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

public extension HTML {
    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: Color) -> some HTML {
        modifier(ForegroundStyleModifier(color: color))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a string.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: String) -> some HTML {
        modifier(ForegroundStyleModifier(colorString: color))
    }

    /// Applies a foreground style to the current element.
    /// - Parameter style: The style to apply
    /// - Returns: The element with the updated style applied.
    func foregroundStyle(_ style: any Style) -> some HTML {
        modifier(ForegroundStyleModifier(style: style))
    }
}

public extension InlineHTML {
    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: Color) -> some InlineHTML {
        modifier(ForegroundStyleModifier(color: color))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a string.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: String) -> some InlineHTML {
        modifier(ForegroundStyleModifier(colorString: color))
    }

    /// Applies a foreground style to the current element.
    /// - Parameter style: The style to apply
    /// - Returns: The element with the updated style applied.
    func foregroundStyle(_ style: any Style) -> some InlineHTML {
        modifier(ForegroundStyleModifier(style: style))
    }
}
