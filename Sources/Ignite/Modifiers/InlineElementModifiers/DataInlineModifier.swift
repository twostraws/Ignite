//
// DataInlineModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private struct DataInlineModifier: InlineElementModifier {
    var name: String
    var value: String
    func body(content: Content) -> some InlineElement {
        var content = content
        content.attributes.data.append(.init(name: name, value: value))
        return content
    }
}

public extension InlineElement {
    /// Adds a data attribute to the element.
    /// - Parameters:
    ///   - name: The name of the data attribute
    ///   - value: The value of the data attribute
    /// - Returns: The modified `HTML` element
    func data(_ name: String, _ value: String) -> some InlineElement {
        modifier(DataInlineModifier(name: name, value: value))
    }
}
