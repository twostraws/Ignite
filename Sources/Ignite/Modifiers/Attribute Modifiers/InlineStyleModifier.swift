//
// InlineStyleModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private extension HTML {
    func inlineStyleModifier(styles: [InlineStyle]) -> any HTML {
        // Custom elements need to be wrapped in a primitive container to store attributes
        var copy: any HTML = self.isPrimitive ? self : Section(self)
        copy.attributes.append(styles: styles)
        return copy
    }
}

public extension HTML {
    /// Adds an inline CSS style property to the HTML element
    /// - Parameters:
    ///   - property: The CSS property to set
    ///   - value: The value to set for the property
    /// - Returns: A modified copy of the element with the style property added
    func style(_ property: Property, _ value: String) -> some HTML {
        AnyHTML(inlineStyleModifier(styles: [.init(property, value: value)]))
    }
}

public extension InlineElement {
    /// Adds an inline CSS style property to the HTML element
    /// - Parameters:
    ///   - property: The CSS property to set
    ///   - value: The value to set for the property
    /// - Returns: A modified copy of the element with the style property added
    func style(_ property: Property, _ value: String) -> some InlineElement {
        AnyHTML(inlineStyleModifier(styles: [.init(property, value: value)]))
    }
}

extension HTML {
    /// Adds an inline style to the element.
    /// - Parameters:
    ///   - property: The CSS property.
    ///   - value: The value.
    /// - Returns: The modified `HTML` element
    func style(_ property: String, _ value: String) -> some HTML {
        AnyHTML(inlineStyleModifier(styles: [.init(property, value: value)]))
    }

    /// Adds inline styles to the element.
    /// - Parameter values: Variable number of `InlineStyle` objects
    /// - Returns: The modified `HTML` element
    func style(_ values: InlineStyle?...) -> some HTML {
        let styles = values.compactMap(\.self)
        return AnyHTML(inlineStyleModifier(styles: styles))
    }

    /// Adds inline styles to the element.
    /// - Parameter styles: An array of `InlineStyle` objects
    /// - Returns: The modified `HTML` element
    func style(_ styles: [InlineStyle]) -> some HTML {
        AnyHTML(inlineStyleModifier(styles: styles))
    }
}
