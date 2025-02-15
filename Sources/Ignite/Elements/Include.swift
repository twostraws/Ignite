//
// Include.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Lets you include arbitrary HTML on a page.
public struct Include: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a grid.
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
    /// - Returns: The HTML for this element.
    public func render() -> String {
        let fileURL = publishingContext.includesDirectory.appending(path: filename)

        do {
            let string = try String(contentsOf: fileURL)
            return string
        } catch {
            publishingContext.addWarning("""
            Failed to find \(filename) in Includes folder; \
            it has been replaced with an empty string.
            """)

            return ""
        }
    }
}
