//
// ForegroundStyleInlineModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies foreground styling to inline elements.
private struct ForegroundStyleInlineModifier: InlineElementModifier {
    /// The foreground style to apply.
    var style: ForegroundStyleType

    /// Creates the modified inline element with the specified foreground style.
    /// - Parameter content: The content to modify.
    /// - Returns: The modified inline element.
    func body(content: Content) -> some InlineElement {
        var modified = content
        switch style {
        case .none: break
        case .gradient(let gradient):
            modified.attributes.append(styles: gradient.styles)
        case .string(let string):
            modified.attributes.append(styles: .init(.color, value: string))
        case .color(let color):
            modified.attributes.append(styles: .init(.color, value: color.description))
        case .style(let foregroundStyle):
            modified.attributes.append(classes: foregroundStyle.rawValue)
        }
        return modified
    }
}

public extension InlineElement {
    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: Color) -> some InlineElement {
        modifier(ForegroundStyleInlineModifier(style: .color(color)))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a string.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: String) -> some InlineElement {
        modifier(ForegroundStyleInlineModifier(style: .string(color)))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter style: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ style: ForegroundStyle) -> some InlineElement {
        modifier(ForegroundStyleInlineModifier(style: .style(style)))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter gradient: The style to apply, specified as a `Gradient` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ gradient: Gradient) -> some InlineElement {
        modifier(ForegroundStyleInlineModifier(style: .gradient(gradient)))
    }
}
