//
// Array-DefinitelyIsHackSorryAboutThat.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

// swiftlint:disable unused_setter_value line_length
/// Not my proudest moment. This extension makes arrays of elements conform
/// to many protocols to make rendering easier. I have no doubt there are better ways
/// of doing this, and I would love this to be rewritten when I (or perhaps you!) have
/// some spare time.
// Array-ElementRendering.swift
extension Array: HeadElement, HTML, HorizontalAligning where Element: HTML {
    public var body: some HTML { self }

    public func render(context: PublishingContext) -> String {
        self.map { $0.render(context: context) }.joined()
    }
}

extension Array: BlockHTML where Element: BlockHTML {
    public var body: some BlockHTML { self }

    public var columnWidth: ColumnWidth {
        get { .automatic }
        set {}
    }

    @MainActor public func render(context: PublishingContext) -> String {
        self.map { $0.render(context: context) }.joined()
    }
}

extension Array: InlineHTML where Element: InlineHTML {
    public var body: some InlineHTML { self }

    @MainActor public func render(context: PublishingContext) -> String {
        self.map { $0.render(context: context) }.joined()
    }
}
