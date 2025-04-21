//
// IDModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
private func idModifier(_ id: String, content: any HTML) -> any HTML {
    guard !id.isEmpty else { return content }
    var copy: any HTML = content.isPrimitive ? content : Section(content)
    copy.attributes.id = id
    return copy
}

@MainActor
private func idModifier(_ id: String, content: any InlineElement) -> any InlineElement {
    guard !id.isEmpty else { return content }
    var copy: any InlineElement = content.isPrimitive ? content : Span(content)
    copy.attributes.id = id
    return copy
}

public extension HTML {
    /// Sets the `HTML` id attribute of the element.
    /// - Parameter id: The HTML ID value to set
    /// - Returns: A modified copy of the element with the HTML id added
    func id(_ id: String) -> some HTML {
        AnyHTML(idModifier(id, content: self))
    }
}

public extension InlineElement {
    /// Sets the `HTML` id attribute of the element.
    /// - Parameter id: The HTML ID value to set
    /// - Returns: A modified copy of the element with the HTML ID added
    func id(_ id: String) -> some InlineElement {
        AnyInlineElement(idModifier(id, content: self))
    }
}
