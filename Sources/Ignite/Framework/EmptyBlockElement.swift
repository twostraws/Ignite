//
// EmptyBlockElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A placeholder block element that renders nothing
/// Used as a default or fallback when no block content is needed
public struct EmptyBlockElement: BlockHTML {
    /// The column width setting for this element when used in a grid layout
    public var columnWidth: ColumnWidth = .automatic

    /// Returns self as the body content since this is an empty element
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// Renders this element as an empty string
    /// - Returns: An empty string
    public func render() -> String {
        ""
    }
}

public extension EmptyBlockElement {
    func id(_ id: String) -> Self {
        attributes.id(id, persistentID: self.id)
        return self
    }

    @discardableResult func `class`(_ classes: String...) -> Self {
        attributes.classes(classes, persistentID: id)
        return self
    }

    func aria(_ key: AriaType, _ value: String) -> Self {
        attributes.aria(key, value, persistentID: id)
        return self
    }

    func data(_ name: String, _ value: String) -> Self {
        attributes.data(name, value, persistentID: id)
        return self
    }

    @discardableResult func style(_ property: Property, _ value: String) -> Self {
        attributes.style(property, value, persistentID: id)
        return self
    }
}
