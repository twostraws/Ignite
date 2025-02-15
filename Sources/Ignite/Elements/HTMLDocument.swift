//
// HTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public struct HTMLDocument: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    private let language: Language
    private let contents: [any RootElement]

    public init(language: Language = .english, @RootElementBuilder contents: () -> [any RootElement]) {
        self.language = language
        self.contents = contents()
    }

    public func render() -> String {
        self.customAttribute(name: "lang", value: language.rawValue)
        self.customAttribute(name: "data-bs-theme", value: "auto")
        var output = "<!doctype html>"
        output += "<html\(attributes.description())>"
        output += contents.map { $0.render() }.joined()
        output += "</html>"
        return output
    }
}
