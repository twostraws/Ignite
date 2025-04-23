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
        output += "<html \(attributes)>"
        output += head.markupString()
        output += body.markupString()
        output += "</html>"
        return Markup(output)
    }
}
