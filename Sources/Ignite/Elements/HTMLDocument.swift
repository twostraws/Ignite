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
    
    private let language: Language
    private let contents: [any HTMLRootElement]
    
    public init(language: Language = .english, @HTMLRootElementBuilder contents: () -> [any HTMLRootElement]) {
        self.language = language
        self.contents = contents()
    }
    
    public func render(context: PublishingContext) -> String {
        self.customAttribute(name: "lang", value: language.rawValue)
        self.customAttribute(name: "data-bs-theme", value: "auto")
        var output = "<!doctype html>"
        output += "<html\(attributes.description())>"
        output += contents.map { element in
            return element.render(context: context)
        }.joined()
        output += "</html>"
        return output
    }
}
