//
// Time.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Represents a specific period in time. It may include the datetime attribute
/// to translate dates into machine-readable format, allowing for better search
/// engine results or custom features such as reminders.
public struct Time<Content: InlineElement>: InlineElement {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The contents of this time tag.
    private var content: Content

    /// This attribute indicates the time and/or date of the element.
    private var dateTime: Date?

    /// Creates a time element with no content.
    /// - Parameter dateTime: The time and/or date of the element
    /// inside the time element.
    public init(dateTime: Date? = nil) where Content == EmptyInlineElement {
        self.content = EmptyInlineElement()
        self.dateTime = dateTime
    }

    /// Creates a time element from one `InlineElement`.
    /// - Parameter singleElement: The element you want to place
    /// - Parameter dateTime: The time and/or date of the element
    /// inside the time element.
    public init(_ singleElement: Content, dateTime: Date? = nil) {
        self.content = singleElement
        self.dateTime = dateTime
    }

    /// Creates a time element from an inline element builder that returns an array of
    /// elements to place inside the time element.
    /// - Parameter dateTime: The time and/or date of the element
    /// - Parameter contents: The elements to place inside the time element.
    public init(dateTime: Date? = nil, @HTMLBuilder content: () -> Content) {
        self.dateTime = dateTime
        self.content = content()
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        var attributes = attributes
        if let dateTime {
            attributes.append(customAttributes: .init(name: "datetime", value: dateTime.asISO8601))
        }
        let contentHTML = content.markupString()
        return Markup("<time\(attributes)>\(contentHTML)</time>")
    }
}
