//
// ForegroundStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//



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

@MainActor private func foregroundStyleModifier(
    _ style: StyleType,
    content: any HTML
) -> any HTML {
    switch style {
    case .none:
        content
    case .gradient(let gradient) where content.isText:
        content.style(styles(for: gradient))
    case .gradient(let gradient):
        Section(content.class("color-inherit"))
            .style(styles(for: gradient))
    case .string(let string) where content.isText:
        content.style(.color, string)
    case .string(let string):
        Section(content.class("color-inherit"))
            .style(.color, string)
    case .color(let color) where content.isText:
        content.style(.color, color.description)
    case .color(let color):
        Section(content.class("color-inherit"))
            .style(.color, color.description)
    case .style(let foregroundStyle):
        content.class(foregroundStyle.rawValue)
    }
}

@MainActor private func foregroundStyleModifier(
    _ style: StyleType,
    content: any InlineElement
) -> any InlineElement {
    switch style {
    case .none:
        content
    case .gradient(let gradient):
        content.style(styles(for: gradient))
    case .string(let string):
        content.style(.color, string)
    case .color(let color):
        content.style(.color, color.description)
    case .style(let foregroundStyle):
        content.class(foregroundStyle.rawValue)
    }
}

public extension HTML {
    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: Color) -> some HTML {
        AnyHTML(foregroundStyleModifier(.color(color), content: self))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a string.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: String) -> some HTML {
        AnyHTML(foregroundStyleModifier(.string(color), content: self))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter style: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ style: ForegroundStyle) -> some HTML {
        AnyHTML(foregroundStyleModifier(.style(style), content: self))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter gradient: The style to apply, specified as a `Gradient` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ gradient: Gradient) -> some HTML {
        AnyHTML(foregroundStyleModifier(.gradient(gradient), content: self))
    }
}

public extension InlineElement {
    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: Color) -> some InlineElement {
        AnyInlineElement(foregroundStyleModifier(.color(color), content: self))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a string.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: String) -> some InlineElement {
        AnyInlineElement(foregroundStyleModifier(.string(color), content: self))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter style: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ style: ForegroundStyle) -> some InlineElement {
        AnyInlineElement(foregroundStyleModifier(.style(style), content: self))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter gradient: The style to apply, specified as a `Gradient` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ gradient: Gradient) -> some InlineElement {
        AnyInlineElement(foregroundStyleModifier(.gradient(gradient), content: self))
    }
}

public extension StyledHTML {
    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: Color) -> Self {
        self.style(.color, color.description)
    }

    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a `String`.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: String) -> Self {
        self.style(.color, color)
    }
}
