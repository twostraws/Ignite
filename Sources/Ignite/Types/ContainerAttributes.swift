//
// ContainerAttributes.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Specifies how a container should be rendered in the HTML output in relation to other containers.
///
/// For certain modifiers, namely animation modifiers, order matters. The order of
/// animation modifiers determines how containers are nested and thereby prioritized.
/// However, regardless of their position in the modifier chain, transform animations
/// should affect the entire element, including its containers. So we need to ensure
/// they are always the outermost *animation* container without affecting the rest of
/// the container chain.
///
enum ContainerType {
    /// A container that handles animations.
    case animation

    /// A container that handles transform animations.
    case transform

    /// A container that handles a click handler.
    case click

    /// A standard container with no special rendering behavior.
    case regular
}

/// A type that holds CSS classes and styles for HTML container elements.
///
/// `ContainerAttributes` provides a way to collect and manage CSS classes and inline styles
/// that should be applied to container elements in the HTML output.
struct ContainerAttributes: Hashable, Sendable {
    /// The type of container, determining its rendering behavior and position in the container stack.
    var type: ContainerType = .regular

    /// The CSS classes to apply to the container
    var classes = OrderedSet<String>()

    /// The inline styles to apply to the container
    var styles = OrderedSet<AttributeValue>()

    /// JavaScript events, such as onclick.
    var events = Set<Event>()

    /// Whether this container has any classes or styles defined
    var isEmpty: Bool { classes.isEmpty && styles.isEmpty && events.isEmpty }

    /// Creates a new container with the specified type, styling, and event handlers.
    /// - Parameters:
    ///   - type: The container's rendering behavior and position in the container stack. Defaults to `.regular`.
    ///   - classes: CSS classes to apply to the container. Defaults to empty.
    ///   - styles: Inline CSS styles to apply to the container. Defaults to empty.
    ///   - events: JavaScript event handlers to attach to the container. Defaults to empty.
    init(
        type: ContainerType = .regular,
        classes: some RandomAccessCollection<String> = OrderedSet<String>(),
        styles: some RandomAccessCollection<AttributeValue> = OrderedSet<AttributeValue>(),
        events: some Collection<Event> = []
    ) {
        self.type = type
        self.classes = OrderedSet(classes)
        self.styles = OrderedSet(styles)
        self.events = Set(events)
    }
}
