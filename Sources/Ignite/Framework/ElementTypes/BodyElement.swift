//
// BodyElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An element that can exist in the `<body>` of an HTML page.
/// - Warning: Do not conform to this type directly.
public protocol BodyElement: MarkupElement {
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
