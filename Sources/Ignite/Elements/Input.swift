//
// Input.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An input element for use in form controls.
struct Input: InlineElement {
    /// The content and behavior of this HTML.
    var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    var isPrimitive: Bool { true }

    func render() -> String {
        "<input\(attributes) />"
    }
}
