//
// ControlLabel.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A form label with support for various styles
struct ControlLabel<Content: InlineElement>: InlineElement {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The text content of the label
    private let text: Content

    /// Creates a new control label with the specified text content.
    /// - Parameter text: The inline element to display within the label.
    init(_ text: Content) {
        self.text = text
    }

    func render() -> Markup {
        let textHTML = text.markupString()
        return Markup("<label\(attributes)>\(textHTML)</label>")
    }
}
