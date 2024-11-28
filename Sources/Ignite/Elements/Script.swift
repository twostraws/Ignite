//
// Script.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Embeds some JavaScript inside this page, either directly or by
/// referencing an external file.
public struct Script: BlockHTML, HeadElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// The external file to load.
    private var file: String?

    /// Direct, inline JavaScript code to execute.
    private var code: String?

    /// Creates a new script that references an external file.
    /// - Parameter file: The URL of the file to load.
    public init(file: String) {
        self.file = file
    }

    /// Creates a new script that references an external file.
    /// - Parameter file: The URL of the file to load.
    public init(file: URL) {
        self.file = file.absoluteString
    }

    /// Embeds some custom, inline JavaScript on this page.
    public init(code: String) {
        self.code = code
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        var attributes = attributes
        attributes.tag = "script"

        if let file {
            attributes.append(customAttributes: .init(name: "src", value: "\(context.site.url.path)\(file)"))
            return attributes.description()
        } else if let code {
            return attributes.description(wrapping: code)
        } else {
            context.addWarning("""
            Creating a script with no source or code should not be possible. \
            Please file a bug report on the Ignite project.
            """)
            return ""
        }
    }
}
