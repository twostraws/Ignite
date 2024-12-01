//
// ContainerAttributes.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that holds CSS classes and styles for HTML container elements.
///
/// `ContainerAttributes` provides a way to collect and manage CSS classes and inline styles
/// that should be applied to container elements in the HTML output.
struct ContainerAttributes: Hashable, Sendable {
    /// Whether this container affects the size of its elements.
    var isTransformContainer: Bool = false

    /// The CSS classes to apply to the container
    var classes = OrderedSet<String>()

    /// The inline styles to apply to the container
    var styles = OrderedSet<AttributeValue>()

    /// JavaScript events, such as onclick.
    var events = Set<Event>()

    /// Whether this container has any classes or styles defined
    var isEmpty: Bool { classes.isEmpty && styles.isEmpty && events.isEmpty }
}
