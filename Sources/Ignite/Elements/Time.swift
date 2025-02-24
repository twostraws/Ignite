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
public struct Time: InlineElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The contents of this time tag.
    public var contents: any InlineElement

    /// This attribute indicates the time and/or date of the element.
    public var dateTime: Date?

    /// Creates a time element with no content.
    /// - Parameter dateTime: The time and/or date of the element
    /// inside the time element.
    public init(dateTime: Date? = nil) {
        self.contents = EmptyHTML()
        self.dateTime = dateTime
    }

    /// Creates a time element from one `InlineElement`.
    /// - Parameter singleElement: The element you want to place
    /// - Parameter dateTime: The time and/or date of the element
    /// inside the time element.
    public init(_ singleElement: any InlineElement, dateTime: Date? = nil) {
        self.contents = singleElement
        self.dateTime = dateTime
    }

    /// Creates a time element from an inline element builder that returns an array of
    /// elements to place inside the time element.
    /// - Parameter dateTime: The time and/or date of the element
    /// - Parameter contents: The elements to place inside the time element.
    public init(dateTime: Date? = nil, @HTMLBuilder contents: () -> some InlineElement) {
        self.dateTime = dateTime
        self.contents = contents()
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        var attributes = attributes
        if let dateTime {
            attributes.append(customAttributes: .init(name: "datetime", value: dateTime.asISO8601))
        }

        return "<time\(attributes)>\(contents)</time>"
    }
}
