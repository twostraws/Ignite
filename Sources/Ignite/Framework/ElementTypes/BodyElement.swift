//
// BodyElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An element that can exist in the `<body>` of an HTML page.
/// - Warning: Do not conform to this type directly.
@MainActor
public protocol BodyElement: Sendable {
    /// The standard set of control attributes for HTML elements.
    var attributes: CoreAttributes { get set }

    /// Converts this element and its children into HTML markup.
    /// - Returns: A string containing the HTML markup
    func render() -> Markup

    /// Whether this HTML belongs to the framework.
    var isPrimitive: Bool { get }
}

public extension BodyElement {
    /// The default status as a primitive element.
    var isPrimitive: Bool { false }

    /// A collection of styles, classes, and attributes.
    var attributes: CoreAttributes {
        get { CoreAttributes() }
        set {} // swiftlint:disable:this unused_setter_value
    }
}

extension BodyElement {
    /// Converts this element and its children into an HTML string with attributes.
    /// - Returns: A string containing the HTML markup
    func markupString() -> String {
        render().string
    }

    /// The publishing context of this site.
    var publishingContext: PublishingContext {
        PublishingContext.shared
    }
}
