//
// Include.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Lets you include arbitrary HTML on a page.
public struct Include: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// The filename you want to bring in, including its extension. This file
    /// must be in your Includes directory.
    let filename: String

    /// Creates a new `Include` instance using the provided filename.
    /// - Parameter filename: The filename you want to bring in,
    /// including its extension. This file must be in your Includes directory.
    public init(_ filename: String) {
        self.filename = filename
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        let fileURL = context.includesDirectory.appending(path: filename)

        do {
            let string = try String(contentsOf: fileURL)
            return string
        } catch {
            context.addWarning("""
            Failed to find \(filename) in Includes folder; \
            it has been replaced with an empty string.
            """)

            return ""
        }
    }
}
