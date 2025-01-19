//
// Declaration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A simple property-value pair of strings that is able to store inline styles
struct Declaration: Hashable, Equatable, Sendable, Comparable, CustomStringConvertible {
    /// The property, e.g. `\.color`.
    var property: String

    /// The declaration's value, e.g. "blue".
    var value: String

    init(property: Property, value: String) {
        self.property = property.rawValue
        self.value = value
    }

    init(property: String, value: String) {
        self.property = property
        self.value = value
    }

    /// The full declaration, e.g. "color: blue""
    public var description: String {
        property + ": " + value
    }

    public static func < (lhs: Declaration, rhs: Declaration) -> Bool {
        lhs.property < rhs.property
    }
}
