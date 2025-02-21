//
// ClassModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that adds a CSS class to an HTML element.
struct ClassModifier: HTMLModifier {
    let classNames: [String]
    /// Adds the specified CSS class to the HTML element
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with the CSS class added
    func body(content: some HTML) -> any HTML {
        let existingNames = classNames.filter { !$0.isEmpty }
        guard !existingNames.isEmpty else { return content }
        var copy = content
        copy.attributes.append(classes: classNames)
        AttributeStore.default.merge(copy.attributes, intoHTML: copy.id)
        return copy
    }
}

public extension HTML {
    /// Adds a CSS class to the HTML element
    /// - Parameter className: The CSS class name to add
    /// - Returns: A modified copy of the element with the CSS class added
    func `class`(_ className: String) -> some HTML {
        modifier(ClassModifier(classNames: [className]))
    }
}

public extension InlineElement {
    /// Adds a CSS class to the HTML element
    /// - Parameter className: The CSS class name to add
    /// - Returns: A modified copy of the element with the CSS class added
    func `class`(_ className: String) -> some InlineElement {
        modifier(ClassModifier(classNames: [className]))
    }
}
