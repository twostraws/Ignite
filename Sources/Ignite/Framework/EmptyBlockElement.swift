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

extension EmptyBlockElement {
    /// The type of HTML this element returns after attributes have been applied.
    public typealias AttributedHTML = Self

    public func id(_ id: String) -> Self {
        attributes.id(id)
        return self
    }

    public func `class`(_ classes: String...) -> Self {
        attributes.classes(classes)
        return self
    }
}
