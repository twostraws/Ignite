//
// InlineStyleInlineModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private struct InlineStyleInlineModifier: InlineElementModifier {
    var styles: [InlineStyle]
    func body(content: Content) -> some InlineElement {
        var content = content
        content.attributes.append(styles: styles)
        return content
    }
}

public extension InlineElement {
    /// Adds an inline CSS style property to the HTML element
    /// - Parameters:
    ///   - property: The CSS property to set
    ///   - value: The value to set for the property
    /// - Returns: A modified copy of the element with the style property added
    func style(_ property: Property, _ value: String) -> some InlineElement {
        modifier(InlineStyleInlineModifier(styles: [.init(property, value: value)]))
    }
}

extension InlineElement {
    /// Adds an inline style to the element.
    /// - Parameters:
    ///   - property: The CSS property.
    ///   - value: The value.
    /// - Returns: The modified `InlineElement` element
    func style(_ property: String, _ value: String) -> some InlineElement {
        modifier(InlineStyleInlineModifier(styles: [.init(property, value: value)]))
    }

    /// Adds inline styles to the element.
    /// - Parameter values: Variable number of `InlineStyle` objects
    /// - Returns: The modified `InlineElement` element
    func style(_ values: InlineStyle?...) -> some InlineElement {
        let styles = values.compactMap(\.self)
        return modifier(InlineStyleInlineModifier(styles: styles))
    }

    /// Adds inline styles to the element.
    /// - Parameter styles: An array of `InlineStyle` objects
    /// - Returns: The modified `InlineElement` element
    func style(_ styles: [InlineStyle]) -> some InlineElement {
        modifier(InlineStyleInlineModifier(styles: styles))
    }
}
