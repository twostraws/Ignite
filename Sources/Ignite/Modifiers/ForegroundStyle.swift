//
// ForegroundStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Common foreground styles that allow for clear readability.
public enum ForegroundStyle: String, Sendable, CaseIterable {
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

/// A modifier that applies foreground color styling to HTML elements,
/// handling both primitive and composite content.
struct ForegroundStyleModifier: HTMLModifier {
    /// The type of style this contains.
    enum Style {
        case none
        case string(String)
        case color(Color)
        case style(ForegroundStyle)
    }

    private var internalStyle: Style

    init(string: String) {
        internalStyle = .string(string)
    }

    init(color: Color) {
        internalStyle = .color(color)
    }

    init(style: ForegroundStyle) {
        internalStyle = .style(style)
    }

    /// Applies the foreground style to the provided HTML content.
    /// - Parameter content: The HTML content to modify
    /// - Returns: The modified HTML content with foreground styling applied
    func body(content: some HTML) -> any HTML {
        switch internalStyle {
        case .none:
            content
        case .string(let string):
            if content.body.isComposite {
                content
                    .containerStyle(.init(.color, value: string))
                    .class("color-inherit")
            } else {
                content.style(.color, string)
            }
        case .color(let color):
            if content.body.isComposite {
                content
                    .containerStyle(.init(.color, value: color.description))
                    .class("color-inherit")
            } else {
                content.style(.color, color.description)
            }
        case .style(let foregroundStyle):
            content.class(foregroundStyle.rawValue)
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
        modifier(ForegroundStyleModifier(string: color))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter style: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    public func foregroundStyle(_ style: ForegroundStyle) -> some HTML {
        modifier(ForegroundStyleModifier(style: style))
    }
}

extension HTML where Self == Image {
    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    public func foregroundStyle(_ color: Color) -> some InlineElement {
        modifier(ForegroundStyleModifier(color: color))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a string.
    /// - Returns: The current element with the updated color applied.
    public func foregroundStyle(_ color: String) -> some InlineElement {
        modifier(ForegroundStyleModifier(string: color))
    }
}
