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
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    private let language: Language
    private let contents: [any RootHTML]

    public init(language: Language = .english, @RootHTMLBuilder contents: () -> [any RootHTML]) {
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

extension HTMLDocument {
    public func id(_ id: String) -> Self {
        attributes.id(id, persistentID: self.id)
        return self
    }

    @discardableResult public func `class`(_ classes: String...) -> Self {
        attributes.classes(classes, persistentID: id)
        return self
    }

    public func aria(_ key: AriaType, _ value: String) -> Self {
        attributes.aria(key, value, persistentID: id)
        return self
    }

    public func data(_ name: String, _ value: String) -> Self {
        attributes.data(name, value, persistentID: id)
        return self
    }

    public func style(_ property: Property, _ value: String) -> Self {
        attributes.style(property, value, persistentID: id)
        return self
    }
}
