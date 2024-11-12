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
extension Array: HeadElement, BlockElement, InlineElement, HTML, HorizontalAligning where Element: HTML {
    public var body: Array<Element> {
        return Array(self)
    }
    
    public var columnWidth: ColumnWidth {
        get { .automatic }
        set { }
    }
    
    public func render(context: PublishingContext) -> String {
        return self.map { element in
            element.render(context: context)
        }.joined()
    }
}
