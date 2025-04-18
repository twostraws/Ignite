//
// InlineStyleModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor private func inlineStyleModifier(
    _ styles: [InlineStyle],
    content: any RenderableElement
) -> any RenderableElement {
    var copy: any RenderableElement = content.isPrimitive ? content : Section(content)
    copy.attributes.append(styles: styles)
    return copy
}

@MainActor private func inlineStyleModifier(
    _ styles: [InlineStyle],
    content: any InlineElement
) -> any InlineElement {
    var copy: any InlineElement = content.isPrimitive ? content : Span(content)
    copy.attributes.append(styles: styles)
    return copy
}

public extension HTML {
    /// Adds an inline CSS style property to the HTML element
    /// - Parameters:
    ///   - property: The CSS property to set
    ///   - value: The value to set for the property
    /// - Returns: A modified copy of the element with the style property added
    func style(_ property: Property, _ value: String) -> some HTML {
        AnyHTML(inlineStyleModifier([.init(property, value: value)], content: self))
    }
}

public extension InlineElement {
    /// Adds an inline CSS style property to the HTML element
    /// - Parameters:
    ///   - property: The CSS property to set
    ///   - value: The value to set for the property
    /// - Returns: A modified copy of the element with the style property added
    func style(_ property: Property, _ value: String) -> some InlineElement {
        AnyInlineElement(inlineStyleModifier([.init(property, value: value)], content: self))
    }
}

public extension FormItem where Self: HTML {
    /// Adds an inline CSS style property to the Element element
    /// - Parameters:
    ///   - property: The CSS property to set
    ///   - value: The value to set for the property
    /// - Returns: A modified copy of the element with the style property added
    func style(_ property: Property, _ value: String) -> some FormItem {
        AnyHTML(inlineStyleModifier([.init(property, value: value)], content: self))
    }
}

public extension FormItem where Self: InlineElement {
    /// Adds an inline CSS style property to the Element element
    /// - Parameters:
    ///   - property: The CSS property to set
    ///   - value: The value to set for the property
    /// - Returns: A modified copy of the element with the style property added
    func style(_ property: Property, _ value: String) -> some FormItem {
        AnyHTML(inlineStyleModifier([.init(property, value: value)], content: self))
    }
}

public extension FormItem {
    /// Adds an inline CSS style property to the Element element
    /// - Parameters:
    ///   - property: The CSS property to set
    ///   - value: The value to set for the property
    /// - Returns: A modified copy of the element with the style property added
    func style(_ property: Property, _ value: String) -> some FormItem {
        AnyHTML(inlineStyleModifier([.init(property, value: value)], content: self))
    }
}

public extension RenderableElement where Self: HeadElement {
    /// Adds an inline CSS style property to the Element element
    /// - Parameters:
    ///   - property: The CSS property to set
    ///   - value: The value to set for the property
    /// - Returns: A modified copy of the element with the style property added
    @discardableResult func style(_ property: Property, _ value: String) -> some HeadElement {
        var copy = self
        copy.attributes.append(styles: .init(property, value: value))
        return copy
    }
}

public extension RenderableElement {
    /// Adds an inline CSS style property to the Element element
    /// - Parameters:
    ///   - property: The CSS property to set
    ///   - value: The value to set for the property
    /// - Returns: A modified copy of the element with the style property added
    @discardableResult func style(_ property: Property, _ value: String) -> some RenderableElement {
        var copy = self
        copy.attributes.append(styles: .init(property, value: value))
        return copy
    }
}

extension HTML {
    /// Adds an inline style to the element.
    /// - Parameters:
    ///   - property: The CSS property.
    ///   - value: The value.
    /// - Returns: The modified `HTML` element
    func style(_ property: String, _ value: String) -> some HTML {
        AnyHTML(inlineStyleModifier([.init(property, value: value)], content: self))
    }

    /// Adds inline styles to the element.
    /// - Parameter values: Variable number of `InlineStyle` objects
    /// - Returns: The modified `HTML` element
    func style(_ values: InlineStyle?...) -> some HTML {
        let styles = values.compactMap(\.self)
        return AnyHTML(inlineStyleModifier(styles, content: self))
    }

    /// Adds inline styles to the element.
    /// - Parameter styles: An array of `InlineStyle` objects
    /// - Returns: The modified `HTML` element
    func style(_ styles: [InlineStyle]) -> some HTML {
        AnyHTML(inlineStyleModifier(styles, content: self))
    }
}

extension InlineElement {
    /// Adds an inline style to the element.
    /// - Parameters:
    ///   - property: The CSS property.
    ///   - value: The value.
    /// - Returns: The modified `InlineElement` element
    func style(_ property: String, _ value: String) -> some InlineElement {
        AnyInlineElement(inlineStyleModifier([.init(property, value: value)], content: self))
    }

    /// Adds inline styles to the element.
    /// - Parameter values: Variable number of `InlineStyle` objects
    /// - Returns: The modified `InlineElement` element
    func style(_ values: InlineStyle?...) -> some InlineElement {
        let styles = values.compactMap(\.self)
        return AnyInlineElement(inlineStyleModifier(styles, content: self))
    }

    /// Adds inline styles to the element.
    /// - Parameter styles: An array of `InlineStyle` objects
    /// - Returns: The modified `InlineElement` element
    func style(_ styles: [InlineStyle]) -> some InlineElement {
        AnyInlineElement(inlineStyleModifier(styles, content: self))
    }
}

//public extension RenderableElement {
//    /// Adds an inline CSS style property to the HTML element
//    /// - Parameters:
//    ///   - property: The CSS property to set
//    ///   - value: The value to set for the property
//    /// - Returns: A modified copy of the element with the style property added
//    func style(_ property: Property, _ value: String) -> some RenderableElement {
//        AnyHTML(inlineStyleModifier([.init(property, value: value)], content: self))
//    }
//}

extension RenderableElement {
    /// Adds inline styles to the element.
    /// - Parameter styles: An array of `InlineStyle` objects
    /// - Returns: The modified `InlineElement` element
    func style(_ styles: [InlineStyle]) -> some RenderableElement {
        AnyHTML(inlineStyleModifier(styles, content: self))
    }
}
