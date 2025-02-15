//
// Label.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A form label with support for various styles
struct Label: InlineElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString

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
