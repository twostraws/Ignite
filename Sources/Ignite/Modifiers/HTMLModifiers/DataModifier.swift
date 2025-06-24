//
// DataModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct DataModifier: HTMLModifier {
    var name: String
    var value: String?
    func body(content: Content) -> some HTML {
        guard let value else { return content }
        var content = content
        content.attributes.data.append(.init(name: name, value: value))
        return content
    }
}

public extension HTML {
    /// Adds a data attribute to the element.
    /// - Parameters:
    ///   - name: The name of the data attribute
    ///   - value: The value of the data attribute
    /// - Returns: The modified `HTML` element
    func data(_ name: String, _ value: String) -> some HTML {
        modifier(DataModifier(name: name, value: value))
    }
}
