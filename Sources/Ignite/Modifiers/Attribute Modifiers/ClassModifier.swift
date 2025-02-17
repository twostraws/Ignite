//
// ClassModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that adds a CSS class to an HTML element.
struct ClassModifier: HTMLModifier {
    let className: String
    /// Adds the specified CSS class to the HTML element
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with the CSS class added
    func body(content: some HTML) -> any HTML {
        guard !className.isEmpty else { return content }
        var copy = content
        copy.attributes.classes.append(className)
        AttributeStore.default.merge(copy.attributes, intoHTML: copy.id)
        return copy
    }
}

public extension HTML {
    /// Adds a CSS class to the HTML element
    /// - Parameter className: The CSS class name to add
    /// - Returns: A modified copy of the element with the CSS class added
    @discardableResult func `class`(_ className: String) -> some HTML {
        modifier(ClassModifier(className: className))
    }
}

public extension InlineElement {
    /// Adds a CSS class to the HTML element
    /// - Parameter className: The CSS class name to add
    /// - Returns: A modified copy of the element with the CSS class added
    @discardableResult func `class`(_ className: String) -> some InlineElement {
        modifier(ClassModifier(className: className))
    }
}
