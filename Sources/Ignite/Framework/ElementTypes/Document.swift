//
// Document.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines an HTML document.
/// - Warning: Do not conform to this protocol directly.
public protocol Document: MarkupElement {
    /// The main content section of the document.
    var body: Body { get }

    /// The metadata section of the document.
    var head: Head { get }
}
