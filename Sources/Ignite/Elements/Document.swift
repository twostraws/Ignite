//
// HTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct Document: HTML {
    /// The content and behavior of this HTML.
    var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    var isPrimitive: Bool { true }

    private let language: Language
    private let contents: [any DocumentElement]

    init(@DocumentElementBuilder contents: () -> [any DocumentElement]) {
        self.language = PublishingContext.shared.environment.language
        self.contents = contents()
    }

    func render() -> String {
        var attributes = attributes
        attributes.append(customAttributes: .init(name: "lang", value: language.rawValue))
        var output = "<!doctype html>"
        output += "<html \(attributes)>"
        output += contents.map { $0.render() }.joined()
        output += "</html>"
        return output
    }
}
