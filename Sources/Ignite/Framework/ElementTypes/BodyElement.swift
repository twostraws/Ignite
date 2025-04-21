//
// BodyElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An element that can exist in the `<body>` of an HTML page.
public protocol BodyElement: MarkupElement, Stylable {}

public extension BodyElement {
    /// A collection of styles, classes, and attributes.
    var attributes: CoreAttributes {
        get { CoreAttributes() }
        set {} // swiftlint:disable:this unused_setter_value
    }
}
