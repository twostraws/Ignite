//
// String.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A small String extension that allows strings to be used directly inside HTML.
/// Useful when you don't want your text to be wrapped in a paragraph or similar.
extension String: InlineHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        self
    }
}

extension String {
    /// The type of HTML this element returns after attributes have been applied.
    public typealias AttributedHTML = Self

    @MainActor public func id(_ id: String) -> Self {
        attributes.id(id, persistentID: self.id)
        return self
    }

    @MainActor @discardableResult public func `class`(_ classes: String...) -> Self {
        attributes.classes(classes, persistentID: id)
        return self
    }
}
