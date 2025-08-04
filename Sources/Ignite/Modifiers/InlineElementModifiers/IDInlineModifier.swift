//
// IDInlineModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private struct IDInlineModifier: InlineElementModifier {
    var id: String
    func body(content: Content) -> some InlineElement {
        var content = content
        guard !id.isEmpty else { return content }
        content.attributes.id = id
        return content
    }
}

public extension InlineElement {
    /// Sets the `HTML` id attribute of the element.
    /// - Parameter id: The HTML ID value to set
    /// - Returns: A modified copy of the element with the HTML ID added
    func id(_ id: String) -> some InlineElement {
        modifier(IDInlineModifier(id: id))
    }
}
