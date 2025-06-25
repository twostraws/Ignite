//
// PageContent.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An opaque container for the content of a page,
/// which is constructed dynamically during the publishing
/// process at runtime.
struct PageContent: HTML {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The content of page being rendered.
    private var content: any HTML

    init(_ content: any HTML) {
        self.content = content
    }

    func render() -> Markup {
        var attributes = attributes
        attributes.append(classes: "ig-main-content")
        return Markup("<div\(attributes)>\(content.markupString())</div>")
    }
}
