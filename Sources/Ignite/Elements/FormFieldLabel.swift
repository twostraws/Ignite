//
// Label.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A form label with support for various styles
struct FormFieldLabel: InlineElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The text content of the label
    private var text: String

    init(text: String) {
        self.text = text
    }

    public func render() -> String {
        "<label\(attributes)>\(text)</label>"
    }
}
