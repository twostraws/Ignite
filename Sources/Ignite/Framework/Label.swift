//
// Label.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A form label with support for various styles
struct Label: InlineHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The text content of the label
    private var text: String

    init(text: String) {
        self.text = text
    }

    public func render() -> String {
        var attributes = attributes
        attributes.tag = "label"
        return attributes.description(wrapping: text)
    }
}

extension Label {
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
