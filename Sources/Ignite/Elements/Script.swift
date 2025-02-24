//
// Script.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Embeds some JavaScript inside this page, either directly or by
/// referencing an external file.
public struct Script: HTML, HeadElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The external file to load.
    private var file: URL?

    /// Direct, inline JavaScript code to execute.
    private var code: String?

    /// Creates a new script that references a local file.
    /// - Parameter file: The URL of the file to load.
    public init(file: String) {
        self.file = URL(string: file)
    }

    /// Creates a new script that references an external file.
    /// - Parameter file: The URL of the file to load.
    public init(file: URL) {
        self.file = file
    }

    /// Embeds some custom, inline JavaScript on this page.
    public init(code: String) {
        self.code = code
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        var attributes = attributes
        if let file {
            let path = publishingContext.path(for: file)
            attributes.append(customAttributes: .init(name: "src", value: path))
            return "<script\(attributes)></script>"
        } else if let code {
            return "<script\(attributes)>\(code)</script>"
        } else {
            publishingContext.addWarning("""
            Creating a script with no source or code should not be possible. \
            Please file a bug report on the Ignite project.
            """)
            return ""
        }
    }
}
