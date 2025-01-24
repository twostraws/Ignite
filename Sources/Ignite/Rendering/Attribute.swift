//
// Attribute.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A simple key-value pair of strings that is able to store custom attributes.
public struct Attribute: Hashable, Equatable, Sendable, Comparable, CustomStringConvertible {
    /// The attribute's name, e.g. "target" or "rel".
    var name: String

    /// The attribute's value, e.g. "myFrame" or "stylesheet".
    var value: String?

    init(name: String, value: String? = nil) {
        self.name = name
        self.value = value
    }

    public var description: String {
        if let value {
            "\(name)=\"\(value)\""
        } else {
            name
        }
    }

    public static func < (lhs: Attribute, rhs: Attribute) -> Bool {
        lhs.name < rhs.name
    }
}

// MARK: - Standard attributes

public extension Attribute {
    static let disabled: Attribute = .init(name: "disabled")
    static let required: Attribute = .init(name: "required")
    static let readOnly: Attribute = .init(name: "readonly")
    static let hidden: Attribute = .init(name: "hidden")
    static let checked: Attribute = .init(name: "checked")
    static let selected: Attribute = .init(name: "selected")
}
