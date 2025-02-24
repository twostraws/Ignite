//
// IDModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that adds a CSS class to an HTML element.
struct IDModifier: HTMLModifier {
    let id: String
    /// Sets the `HTML` id attribute of the element.
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with the CSS class added
    func body(content: some HTML) -> any HTML {
        guard !id.isEmpty else { return content }
        var copy = content
        copy.attributes.id = id
        return copy
    }
}

public extension HTML {
    /// Sets the `HTML` id attribute of the element.
    /// - Parameter id: The HTML ID value to set
    /// - Returns: A modified copy of the element with the HTML id added
    func id(_ id: String) -> some HTML {
        modifier(IDModifier(id: id))
    }
}

public extension InlineElement {
    /// Sets the `HTML` id attribute of the element.
    /// - Parameter id: The HTML ID value to set
    /// - Returns: A modified copy of the element with the HTML ID added
    func id(_ id: String) -> some InlineElement {
        modifier(IDModifier(id: id))
    }
}
