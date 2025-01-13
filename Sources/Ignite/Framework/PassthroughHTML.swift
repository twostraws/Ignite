//
// PassthroughHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that enables HTML elements to pass their content and attributes through to their children.
///
/// Elements that conform to `PassthroughHTML` act as transparent containers,
/// allowing their content and styling to flow through to their child elements.
@MainActor protocol PassthroughHTML: BlockHTML {
    /// The child elements contained within this HTML element.
    var items: [any HTML] { get }

    /// The attributes that should be passed through to child elements.
    var attributes: CoreAttributes { get }
}
