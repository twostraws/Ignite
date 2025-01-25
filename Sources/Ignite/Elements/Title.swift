//
// Title.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Provides the title for a given page, which is rendered in the browser and also
/// appears in search engine results.
public struct Title: HeadElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// A plain-text string for the page title.
    var text: String

    /// Creates a new page title using the plain-text string provided.
    /// - Parameter text: The title to use for this page.
    public init(_ text: String) {
        self.text = text
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        "<title>\(text)\(publishingContext.site.titleSuffix)</title>"
    }
}

extension Title {
    /// The type of HTML this element returns after attributes have been applied.
    public typealias AttributedHTML = Self

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
