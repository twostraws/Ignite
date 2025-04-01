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

public extension HTML {
    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: Color) -> some HTML {
        AnyHTML(foregroundStyleModifier(.color(color)))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a string.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: String) -> some HTML {
        AnyHTML(foregroundStyleModifier(.string(color)))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter style: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ style: ForegroundStyle) -> some HTML {
        AnyHTML(foregroundStyleModifier(.style(style)))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter gradient: The style to apply, specified as a `Gradient` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ gradient: Gradient) -> some HTML {
        AnyHTML(foregroundStyleModifier(.gradient(gradient)))
    }
}

public extension InlineElement {
    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: Color) -> some InlineElement {
        AnyHTML(foregroundStyleModifier(.color(color)))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a string.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: String) -> some InlineElement {
        AnyHTML(foregroundStyleModifier(.string(color)))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter style: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ style: ForegroundStyle) -> some InlineElement {
        AnyHTML(foregroundStyleModifier(.style(style)))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter gradient: The style to apply, specified as a `Gradient` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ gradient: Gradient) -> some InlineElement {
        AnyHTML(foregroundStyleModifier(.gradient(gradient)))
    }
}

public extension HTML where Self == Image {
    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: Color) -> some InlineElement {
        AnyHTML(foregroundStyleModifier(.color(color)))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a string.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: String) -> some InlineElement {
        AnyHTML(foregroundStyleModifier(.string(color)))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter gradient: The style to apply, specified as a `Gradient` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ gradient: Gradient) -> some InlineElement {
        AnyHTML(foregroundStyleModifier(.gradient(gradient)))
    }
}

public extension StyledHTML {
    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: Color) -> Self {
        self.style(.color, color.description)
    }
}

/// The type of style this contains.
private enum StyleType {
    case none
    case string(String)
    case color(Color)
    case style(ForegroundStyle)
    case gradient(Gradient)
}

/// The inline styles required to create text gradients.
private func styles(for gradient: Gradient) -> [InlineStyle] {
    [.init(.backgroundImage, value: gradient.description),
     .init(.backgroundClip, value: "text"),
     .init(.color, value: "transparent")]
}

private extension HTML {
    func foregroundStyleModifier(_ style: StyleType) -> any HTML {
        switch style {
        case .none:
            self
        case .gradient(let gradient) where self.isTextualElement:
            self.style(styles(for: gradient))
        case .gradient(let gradient):
            Section(self.class("color-inherit"))
                .style(styles(for: gradient))
        case .string(let string) where self.isTextualElement:
            self.style(.color, string)
        case .string(let string):
            Section(self.class("color-inherit"))
                .style(.color, string)
        case .color(let color) where self.isTextualElement:
            self.style(.color, color.description)
        case .color(let color):
            Section(self.class("color-inherit"))
                .style(.color, color.description)
        case .style(let foregroundStyle):
            self.class(foregroundStyle.rawValue)
        }
    }
}
