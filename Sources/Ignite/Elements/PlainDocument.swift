//
// PlainDocument.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An HTML document with no extra attributes applied.
public struct PlainDocument: Document {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    private var language: Language
    public var head: Head
    public var body: Body

    init(head: Head, body: Body) {
        self.language = PublishingContext.shared.environment.language
        self.head = head
        self.body = body
    }

    public init(@DocumentElementBuilder content: () -> (head: Head, body: Body)) {
        self.language = PublishingContext.shared.environment.language
        self.head = content().head
        self.body = content().body
    }

    public func markup() -> Markup {
        var attributes = attributes
        attributes.append(customAttributes: .init(name: "lang", value: language.rawValue))

        let bodyMarkup = body.markup()
        // Deferred head rendering to accommodate for context updates during body rendering
        let headMarkup = head.markup()

        var output = "<!doctype html>"
        output += "<html\(attributes)>"
        output += headMarkup.string
        output += bodyMarkup.string
        output += "</html>"
        return Markup(output)
    }
}
