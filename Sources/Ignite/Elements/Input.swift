//
// Input.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An input element for use in form controls.
struct Input: InlineElement {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    func render() -> Markup {
        Markup("<input\(attributes) />")
    }
}
