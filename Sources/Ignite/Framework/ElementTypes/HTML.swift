//
// HTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines the core behavior and
/// structure of `HTML` elements in Ignite.
@MainActor
public protocol HTML: Sendable {
    /// The type of HTML content this element contains.
    associatedtype Body: HTML

    /// The content and behavior of this `HTML` element.
    @HTMLBuilder var body: Body { get }

    /// The standard set of control attributes for HTML elements.
    var attributes: CoreAttributes { get set }

    /// Converts this element and its children into HTML markup.
    /// - Returns: A string containing the HTML markup
    func render() -> Markup
}

public extension HTML {
    /// A collection of styles, classes, and attributes.
    var attributes: CoreAttributes {
        get { CoreAttributes() }
        set {} // swiftlint:disable:this unused_setter_value
    }

    /// Generates the complete `HTML` string representation of the element.
    func render() -> Markup {
        body.render()
    }
}

extension HTML {
    /// The publishing context of this site.
    var publishingContext: PublishingContext {
        PublishingContext.shared
    }

    /// Converts this element and its children into an HTML string with attributes.
    /// - Returns: A string containing the HTML markup
    func markupString() -> String {
        render().string
    }

    /// The default status as a primitive element.
    var isPrimitive: Bool {
        Self.Body.self == Never.self
    }

    /// Checks if this element is an empty HTML element.
    var isEmptyHTML: Bool {
        render().isEmpty
    }

    /// Whether the outermost element of this type is a `<div>`
    /// that can position its contents.
    var requiresPositioningContext: Bool {
        render().string.hasPrefix("<div") == false
    }
}

extension HTML {
    /// Adds an event handler to the element.
    /// - Parameters:
    ///   - name: The name of the event (e.g., "click", "mouseover")
    ///   - actions: Array of actions to execute when the event occurs
    /// - Returns: The modified `HTML` element
    mutating func addEvent(name: String, actions: [Action]) {
        guard !actions.isEmpty else { return }
        let event = Event(name: name, actions: actions)
        attributes.events.append(event)
    }

    /// Sets the tabindex behavior for this element.
    /// - Parameter tabFocus: The TabFocus enum value defining keyboard navigation behavior
    /// - Returns: The modified HTML element
    /// - Note: Adds appropriate HTML attribute based on TabFocus enum
    func tabFocus(_ tabFocus: TabFocus) -> some HTML {
        customAttribute(name: tabFocus.htmlName, value: tabFocus.value)
    }

    func subviews() -> SubviewsCollection {
        SubviewsCollection(self)
    }
}

public extension HTML {
    func modifier<M: HTMLModifier>(_ modifier: M) -> some HTML {
        ModifiedHTML(content: self, modifier: modifier)
    }
}
