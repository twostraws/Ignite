//
// ForEach.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

///// A structure that creates HTML content by mapping over a sequence of data
public struct ForEach<Data: Sequence, Content: HTML>: InlineElement, BlockElement {
    /// The body content created by mapping over the data sequence
    public var body: some HTML { self }

    /// How many columns this should occupy when placed in a section
    public var columnWidth: ColumnWidth = .automatic

    /// The sequence of data to iterate over
    private let data: Data

    /// The closure that transforms each data element into HTML content
    private let content: (Data.Element) -> Content

    /// Creates a new ForEach instance that generates HTML content from a sequence
    /// - Parameters:
    ///   - data: The sequence to iterate over
    ///   - content: A closure that converts each element into HTML content
    public init(_ data: Data, @HTMLBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }

    /// Renders the ForEach content, handling special cases for list items
    /// - Parameter context: The current publishing context
    /// - Returns: The rendered HTML string
    public func render(context: PublishingContext) -> String {
        var output = ""

        for item in HTMLSequence(data.map(content)) {
            if let item = item as? AnyHTML, // Items will be AnyHTML via the @HTMLBuilder implementation
               !(item.wrapped is ListItem), // Check if we're inside a List before wrapping in <li>
               attributes.description().contains("<li>") {
                output += "<li>\(item.render(context: context))</li>"
            } else {
                output += item.render(context: context)
            }
        }

        return output
    }
}
