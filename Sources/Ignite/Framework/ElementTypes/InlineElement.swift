//
// InlineHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An element that exists inside a block element, such as an emphasized
/// piece of text.
@MainActor
public protocol InlineElement: BodyElement, CustomStringConvertible {
    /// The type of HTML content this element contains.
    associatedtype Body: InlineElement

    /// The content and behavior of this element.
    @InlineElementBuilder var body: Body { get }
}

public extension InlineElement {
    /// The complete string representation of the element.
    nonisolated var description: String {
        MainActor.assumeIsolated {
            self.markupString()
        }
    }

    /// Generates the complete HTML string representation of the element.
    func render() -> Markup {
        body.render()
    }
}

extension InlineElement {
    /// Adds an event handler to the element.
    /// - Parameters:
    ///   - name: The name of the event (e.g., "click", "mouseover")
    ///   - actions: Array of actions to execute when the event occurs
    /// - Returns: The modified `InlineElement`
    mutating func addEvent(name: String, actions: [Action]) {
        guard !actions.isEmpty else { return }
        let event = Event(name: name, actions: actions)
        attributes.events.append(event)
    }

    /// Checks if this element is `EmptyInlineElement`
    var isEmpty: Bool {
        if let collection = self as? InlineElementCollection {
            collection.elements.allSatisfy { $0 is EmptyInlineElement }
        } else {
            self is EmptyInlineElement
        }
    }

    /// A Boolean value indicating whether this represents `Image`.
    var isImage: Bool {
        if let anyHTML = body as? AnyInlineElement {
            anyHTML.wrapped is Image
        } else {
            body is Image
        }
    }
}
