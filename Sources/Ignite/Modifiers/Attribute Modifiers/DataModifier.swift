//
// DataModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private extension HTML {
    func dataModifier(name: String, value: String) -> any HTML {
        // Custom elements need to be wrapped in a primitive container to store attributes
        guard value.isEmpty == false else { return self }
        var copy: any HTML = self.isPrimitive ? self : Section(self)
        copy.attributes.data.append(.init(name: name, value: value))
        return copy
    }
}

public extension HTML {
    /// Adds a data attribute to the element.
    /// - Parameters:
    ///   - name: The name of the data attribute
    ///   - value: The value of the data attribute
    /// - Returns: The modified `HTML` element
    func data(_ name: String, _ value: String) -> some HTML {
        AnyHTML(dataModifier(name: name, value: value))
    }
}

public extension InlineElement {
    /// Adds a data attribute to the element.
    /// - Parameters:
    ///   - name: The name of the data attribute
    ///   - value: The value of the data attribute
    /// - Returns: The modified `HTML` element
    func data(_ name: String, _ value: String) -> some InlineElement {
        AnyHTML(dataModifier(name: name, value: value))
    }
}
