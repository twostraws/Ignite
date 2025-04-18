//
// HTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines the core behavior and structure of `HTML` elements in Ignite.
///
/// The `HTML` protocol serves as the foundation for building web components in a type-safe,
/// composable manner. Elements conforming to this protocol can be used anywhere in your site's
/// hierarchy and automatically integrate with Ignite's attribute management and animation systems.
///
/// You typically don't conform to `HTML` directly. Instead, use one of the built-in elements like
/// `Div`, `Paragraph`, or `Link`, or create custom components by conforming to `HTMLRootElement`.
@MainActor
public protocol HTML: RenderableElement, Stylable {
    /// The type of HTML content this element contains.
    associatedtype Body: HTML

    /// The content and behavior of this `HTML` element.
    @HTMLBuilder var body: Body { get }
}

public extension HTML {
    /// Generates the complete `HTML` string representation of the element.
    func render() -> String {
        body.render()
    }
}

extension HTML {
    /// The Bootstrap class that sizes this element in a grid.
    var columnWidth: String {
        if let width = attributes.classes.first(where: {
            $0.starts(with: "col-md-")
        }) {
            return width
        }
        return "col"
    }

    /// Checks if this element is an empty HTML element.
    var isEmpty: Bool {
        if let collection = self as? HTMLCollection {
            collection.elements.allSatisfy { $0 is EmptyHTML }
        } else {
            self is EmptyHTML
        }
    }

    /// A Boolean value indicating whether this represents `Text`.
    var isText: Bool {
        if let anyHTML = body as? AnyHTML {
            anyHTML.wrapped is Text
        } else {
            body is Text
        }
    }

    /// A Boolean value indicating whether this represents `Section`.
    var isSection: Bool {
        if let anyHTML = body as? AnyHTML {
            anyHTML.wrapped is Section
        } else {
            body is Section
        }
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

    /// Adjusts the number of columns assigned to this element.
    /// - Parameter width: The new number of columns to use.
    mutating func columnWidth(_ width: ColumnWidth) {
        attributes.classes.append(width.className)
    }
}
