//
// HTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public struct Document: MarkupElement {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    private let language: Language
    private let head: Head
    private let body: Body

    init(head: Head, body: Body) {
        self.language = PublishingContext.shared.environment.language
        self.head = head
        self.body = body
    }

    public func markup() -> Markup {
        var attributes = attributes
        attributes.append(customAttributes: .init(name: "lang", value: language.rawValue))
        var output = "<!doctype html>"
        output += "<html\(attributes)>"
        let bodyMarkup = body.markup()
        // Deferred head rendering to accommodate for context updates during body rendering
        let headMarkup = head.markup()
        output += headMarkup.string
        output += bodyMarkup.string
        output += "</html>"
        return Markup(output)
    }
}
