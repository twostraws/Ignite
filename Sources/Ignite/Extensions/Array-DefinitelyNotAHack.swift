//
// Array-DefinitelyIsHackSorryAboutThat.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

// swiftlint:disable unused_setter_value
extension Array: HeadElement, HTML, HorizontalAligning where Element: HTML {
    public var body: some HTML { self }

    public func render() -> String {
        self.map { $0.render() }.joined()
    }
}

extension Array: BlockHTML where Element: BlockHTML {
    public var body: some BlockHTML { self }

    public var columnWidth: ColumnWidth {
        get { .automatic }
        set {}
    }

    @MainActor public func render() -> String {
        self.map { $0.render() }.joined()
    }
}

extension Array: InlineHTML where Element: InlineHTML {
    public var body: some InlineHTML { self }

    @MainActor public func render() -> String {
        self.map { $0.render() }.joined()
    }
}
// swiftlint:enable unused_setter_value
