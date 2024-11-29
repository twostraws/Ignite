//
// HTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public struct HTMLDocument: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    private let language: Language
    private let contents: [any RootHTML]
    
    public init(language: Language = .english, @RootHTMLBuilder contents: () -> [any RootHTML]) {
        self.language = language
        self.contents = contents()
    }

    public func render(context: PublishingContext) -> String {
        self.customAttribute(name: "lang", value: language.rawValue)
        self.customAttribute(name: "data-bs-theme", value: "auto")
        var output = "<!doctype html>"
        output += "<html\(attributes.description())>"
        output += contents.map { $0.render(context: context) }.joined()
        output += "</html>"
        return output
    }
}
