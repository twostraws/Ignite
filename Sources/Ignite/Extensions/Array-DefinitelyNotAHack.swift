//
// Array-DefinitelyIsHackSorryAboutThat.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

// swiftlint:disable unused_setter_value
extension Array: HeadElement, HTML, HorizontalAligning where Element: HTML {
    /// The type of HTML this element returns after attributes have been applied.
    public typealias AttributedHTML = Self

    public var body: some HTML { self }

    public func render() -> String {
        self.map { $0.render() }.joined()
    }

    public func id(_ id: String) -> Self {
        attributes.id(id, persistentID: self.id)
        return self
    }

    @discardableResult public func `class`(_ classes: String...) -> Self {
        attributes.classes(classes, persistentID: id)
        return self
    }

    public func aria(_ key: AriaType, _ value: String) -> Self {
        attributes.aria(key, value, persistentID: self.id)
        return self
    }

    public func data(_ key: String, _ value: String) -> Self {
        attributes.data(key, value, persistentID: self.id)
        return self
    }

    public func style(_ property: Property, _ value: String) -> Self {
        attributes.style(property, value, persistentID: self.id)
        return self
    }
}

extension Array: BlockHTML where Element: BlockHTML {
    /// The type of HTML this element returns after attributes have been applied.
    public typealias AttributedHTML = Self

    public var body: some BlockHTML { self }

    public var columnWidth: ColumnWidth {
        get { .automatic }
        set {}
    }

    @MainActor public func render() -> String {
        self.map { $0.render() }.joined()
    }

    @MainActor public func id(_ id: String) -> Self {
        attributes.id(id, persistentID: self.id)
        return self
    }

    @discardableResult
    @MainActor public func `class`(_ classes: String...) -> Self {
        attributes.classes(classes, persistentID: id)
        return self
    }

    @MainActor public func aria(_ key: AriaType, _ value: String) -> Self {
        attributes.aria(key, value, persistentID: self.id)
        return self
    }

    @MainActor public func data(_ key: String, _ value: String) -> Self {
        attributes.data(key, value, persistentID: self.id)
        return self
    }

    @MainActor public func style(_ property: Property, _ value: String) -> Self {
        attributes.style(property, value, persistentID: self.id)
        return self
    }
}

extension Array: InlineHTML where Element: InlineHTML {
    /// The type of HTML this element returns after attributes have been applied.
    public typealias AttributedHTML = Self

    public var body: some InlineHTML { self }

    @MainActor public func render() -> String {
        self.map { $0.render() }.joined()
    }

    @MainActor public func id(_ id: String) -> Self {
        attributes.id(id, persistentID: self.id)
        return self
    }

    @discardableResult
    @MainActor public func `class`(_ classes: String...) -> Self {
        attributes.classes(classes, persistentID: id)
        return self
    }

    @MainActor public func aria(_ key: AriaType, _ value: String) -> Self {
        attributes.aria(key, value, persistentID: self.id)
        return self
    }

    @MainActor public func data(_ key: String, _ value: String) -> Self {
        attributes.data(key, value, persistentID: self.id)
        return self
    }

    @MainActor public func style(_ property: Property, _ value: String) -> Self {
        attributes.style(property, value, persistentID: self.id)
        return self
    }
}
// swiftlint:enable unused_setter_value
