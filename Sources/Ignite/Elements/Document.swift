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

    /// Use PublishingContext language as default.
    private var language: Language = PublishingContext.shared.site.language
    private let contents: [any DocumentElement]

    init(language: Language = .english, @DocumentElementBuilder contents: () -> [any DocumentElement]) {
        self.language = language
        self.contents = contents()
    }

    func render() -> String {
        var attributes = attributes
        attributes.add(customAttributes: .init(name: "lang", value: language.rawValue))
        attributes.add(customAttributes: .init(name: "data-bs-theme", value: "auto"))
        var output = "<!doctype html>"
        output += "<html \(attributes)>"
        output += contents.map { $0.render() }.joined()
        output += "</html>"
        return output
    }
}
