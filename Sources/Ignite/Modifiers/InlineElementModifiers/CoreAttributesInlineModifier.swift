//
// CoreAttributesInlineModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private struct CoreAttributesInlineModifier: InlineElementModifier {
    var attributes: CoreAttributes
    func body(content: Content) -> some InlineElement {
        var content = content
        content.attributes.merge(attributes)
        return content
    }
}

extension InlineElement {
    /// Merges a complete set of core attributes into this element.
    /// - Parameter attributes: The CoreAttributes to merge with existing attributes
    /// - Returns: The modified `HTML` element
    func attributes(_ attributes: CoreAttributes) -> some InlineElement {
        modifier(CoreAttributesInlineModifier(attributes: attributes))
    }
}
