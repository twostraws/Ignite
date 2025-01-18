//
// DataAttributeModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that adds custom data attributes to an HTML element.
struct DataAttributeModifier: HTMLModifier {
    let name: String
    let value: String

    func body(content: some HTML) -> any HTML {
        content._data(name, value)
    }
}

public extension HTML {
    /// Adds a data attribute to the HTML element.
    /// - Parameters:
    ///   - name: The key for the data attribute (without the "data-" prefix).
    ///   - value: The value for the data attribute.
    /// - Returns: A modified HTML element with the specified data attribute.
    func data(_ name: String, _ value: String) -> some HTML {
        modifier(DataAttributeModifier(name: name, value: value))
    }
}

public extension InlineHTML {
    /// Adds a data attribute to the HTML element.
    /// - Parameters:
    ///   - key: The key for the data attribute (without the "data-" prefix).
    ///   - value: The value for the data attribute.
    /// - Returns: A modified HTML element with the specified data attribute.
    func data(_ name: String, _ value: String) -> some InlineHTML {
        modifier(DataAttributeModifier(name: name, value: value))
    }
}

public extension BlockHTML {
    /// Adds a data attribute to the HTML element.
    /// - Parameters:
    ///   - key: The key for the data attribute (without the "data-" prefix).
    ///   - value: The value for the data attribute.
    /// - Returns: A modified HTML element with the specified data attribute.
    func data(_ name: String, _ value: String) -> some BlockHTML {
        modifier(DataAttributeModifier(name: name, value: value))
    }
}
