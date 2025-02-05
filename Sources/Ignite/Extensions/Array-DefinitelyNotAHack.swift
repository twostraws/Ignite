//
// Array-DefinitelyIsHackSorryAboutThat.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension Array: HeadElement, HTML where Element: HTML {
    public var body: some HTML { self }

    public func render() -> String {
        self.map { $0.render() }.joined()
    }
}

extension Array: InlineHTML where Element: InlineHTML {
    public var body: some InlineHTML { self }

    @MainActor public func render() -> String {
        self.map { $0.render() }.joined()
    }
}
