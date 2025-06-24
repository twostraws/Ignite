//
// InlineStyleModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies inline CSS styles to HTML elements.
private struct InlineStyleModifier: HTMLModifier {
    /// The inline styles to apply.
    var styles: [InlineStyle]

    /// Applies the inline styles to the content.
    func body(content: Content) -> some HTML {
        var content = content
        content.attributes.append(styles: styles)
        return content
    }
}

public extension HTML {
    /// Adds an inline CSS style property to the HTML element
    /// - Parameters:
    ///   - property: The CSS property to set
    ///   - value: The value to set for the property
    /// - Returns: A modified copy of the element with the style property added
    func style(_ property: Property, _ value: String) -> some HTML {
        modifier(InlineStyleModifier(styles: [.init(property, value: value)]))
    }
}

extension HTML {
    /// Adds an inline style to the element.
    /// - Parameters:
    ///   - property: The CSS property.
    ///   - value: The value.
    /// - Returns: The modified `HTML` element
    func style(_ property: String, _ value: String) -> some HTML {
        modifier(InlineStyleModifier(styles: [.init(property, value: value)]))
    }

    /// Adds inline styles to the element.
    /// - Parameter values: Variable number of `InlineStyle` objects
    /// - Returns: The modified `HTML` element
    func style(_ values: InlineStyle?...) -> some HTML {
        let styles = values.compactMap(\.self)
        return modifier(InlineStyleModifier(styles: styles))
    }

    /// Adds inline styles to the element.
    /// - Parameter styles: An array of `InlineStyle` objects
    /// - Returns: The modified `HTML` element
    func style(_ styles: [InlineStyle]) -> some HTML {
        modifier(InlineStyleModifier(styles: styles))
    }
}
