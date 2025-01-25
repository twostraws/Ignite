//
// EmptyHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A placeholder HTML element that renders nothing
/// Used as a default or fallback when no content is needed
public struct EmptyHTML: HTML, InlineHTML, RootHTML {
    /// Creates a new empty HTML element
    public init() {}

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

extension EmptyHTML {
    /// The type of HTML this element returns after attributes have been applied.
    public typealias AttributedHTML = Self

    public func id(_ id: String) -> Self {
        attributes.id(id, persistentID: self.id)
        return self
    }

    @discardableResult public func `class`(_ classes: String...) -> Self {
        attributes.classes(classes, persistentID: id)
        return self
    }
}
