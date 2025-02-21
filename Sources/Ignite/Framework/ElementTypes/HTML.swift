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
public protocol HTML: CustomStringConvertible, Sendable {
    /// A unique identifier used to track this element's state and attributes.
    var id: String { get }

    /// Whether this HTML belongs to the framework.
    var isPrimitive: Bool { get }

    /// The type of HTML content this element contains.
    associatedtype Body: HTML

    /// The content and behavior of this `HTML` element.
    @HTMLBuilder var body: Body { get }

    /// Converts this element and its children into an HTML string with attributes.
    /// - Returns: A string containing the rendered HTML
    func render() -> String
}

public extension HTML {
    /// The complete `HTML` string representation of the element.
    nonisolated var description: String {
        MainActor.assumeIsolated {
            self.render()
        }
    }

    /// A unique identifier generated from the element's type and source location.
    var id: String {
        String(describing: self).truncatedHash
    }

    /// The default status as a primitive element.
    var isPrimitive: Bool { false }

    /// Generates the complete `HTML` string representation of the element.
    func render() -> String {
        body.render()
    }
}

extension HTML {
    /// A collection of styles, classes, and attributes managed by the `AttributeStore` for this element.
    var attributes: CoreAttributes {
        get { AttributeStore.default.attributes(for: id) }
        set { AttributeStore.default.merge(newValue, intoHTML: id) }
    }

    /// The publishing context of this site.
    var publishingContext: PublishingContext {
        PublishingContext.default
    }

    /// Checks if this element is an empty HTML element.
    var isEmptyHTML: Bool {
        if let collection = self as? HTMLCollection {
            collection.elements.allSatisfy { $0 is EmptyHTML }
        } else {
            self is EmptyHTML
        }
    }

    /// How many columns this should occupy when placed in a grid.
    var columnWidth: ColumnWidth {
        attributes.columnWidth
    }

    /// A Boolean value indicating whether this element contains multiple child elements.
    var isComposite: Bool {
        let bodyContent = body

        // Unwrap AnyHTML if needed
        let unwrappedContent: Any
        if let anyHTML = bodyContent as? AnyHTML {
            unwrappedContent = anyHTML.wrapped
        } else {
            unwrappedContent = bodyContent
        }

        if unwrappedContent is Text {
            return false
        }

        // Check for multiple elements using Mirror
        let mirror = Mirror(reflecting: unwrappedContent)

        // Check for elements array (like in HTMLGroup)
        if let items = mirror.children.first(where: { $0.label == "elements" })?.value as? [any HTML] {
            return items.count > 1
        }

        // Check for items property (like in Group)
        if let items = mirror.children.first(where: { $0.label == "items" })?.value as? any HTML {
            let itemsMirror = Mirror(reflecting: items)
            return itemsMirror.children.count > 0
        }

        // Check if it's a custom HTML component by looking at its body
        if let htmlBody = mirror.children.first(where: { $0.label == "body" })?.value {
            let bodyMirror = Mirror(reflecting: htmlBody)
            return bodyMirror.children.count > 1
        }

        return false
    }
}

extension HTML {
    /// Adds a data attribute to the element.
    /// - Parameters:
    ///   - name: The name of the data attribute
    ///   - value: The value of the data attribute
    /// - Returns: The modified `HTML` element
    func data(_ name: String, _ value: String?) -> Self {
        guard let value else { return self }
        var attributes = attributes
        attributes.data.append(Attribute(name: name, value: value))
        AttributeStore.default.merge(attributes, intoHTML: id)
        return self
    }

    /// Adds inline styles to the element.
    /// - Parameter values: Variable number of `InlineStyle` objects
    /// - Returns: The modified `HTML` element
    func style(_ values: InlineStyle?...) -> Self {
        var attributes = attributes
        attributes.styles.formUnion(values.compactMap(\.self))
        AttributeStore.default.merge(attributes, intoHTML: id)
        return self
    }

    /// Adds inline styles to the element.
    /// - Parameter values: An array of `InlineStyle` objects
    /// - Returns: The modified `HTML` element
    func style(_ values: [InlineStyle]) -> Self {
        var attributes = attributes
        attributes.styles.formUnion(values)
        AttributeStore.default.merge(attributes, intoHTML: id)
        return self
    }

    /// Adds an inline style to the element.
    /// - Parameters:
    ///   - property: The CSS property.
    ///   - value: The value.
    /// - Returns: The modified `HTML` element
    func style(_ property: String, _ value: String) -> Self {
        var attributes = attributes
        attributes.styles.append(.init(property, value: value))
        AttributeStore.default.merge(attributes, intoHTML: id)
        return self
    }

    /// Adds an event handler to the element.
    /// - Parameters:
    ///   - name: The name of the event (e.g., "click", "mouseover")
    ///   - actions: Array of actions to execute when the event occurs
    /// - Returns: The modified `HTML` element
    func addEvent(name: String, actions: [Action]) {
        guard !actions.isEmpty else { return }
        var attributes = attributes
        attributes.events.append(Event(name: name, actions: actions))
        AttributeStore.default.merge(attributes, intoHTML: id)
    }

    /// Merges a complete set of core attributes into this element.
    /// - Parameter attributes: The CoreAttributes to merge with existing attributes
    /// - Returns: The modified HTML element
    /// - Note: Uses AttributeStore for persistent storage and merging
    func attributes(_ attributes: CoreAttributes) -> Self {
        AttributeStore.default.merge(attributes, intoHTML: id)
        return self
    }

    /// Sets the tabindex behavior for this element.
    /// - Parameter tabFocus: The TabFocus enum value defining keyboard navigation behavior
    /// - Returns: The modified HTML element
    /// - Note: Adds appropriate HTML attribute based on TabFocus enum
    func tabFocus(_ tabFocus: TabFocus) -> some HTML {
        customAttribute(name: tabFocus.htmlName, value: tabFocus.value)
    }

    func tag(_ tag: String) {
        var attributes = attributes
        attributes.tag = tag
        AttributeStore.default.merge(attributes, intoHTML: id)
    }

    /// Adjusts the number of columns assigned to this element.
    /// - Parameter width: The new number of columns to use.
    /// - Returns: A copy of the current element with the adjusted column width.
    @discardableResult func columnWidth(_ width: ColumnWidth) -> Self {
        var attributes = attributes
        attributes.columnWidth = width
        AttributeStore.default.merge(attributes, intoHTML: id)
        return self
    }
}

// MARK: - Helper Methods

/// Recursively flattens nested HTML content into a single array, unwrapping any body properties.
/// - Parameter content: The content to flatten and unwrap
/// - Returns: An array of unwrapped HTML elements
@MainActor func flatUnwrap(_ content: Any) -> [any HTML] {
    if let array = content as? [Any] {
        array.flatMap { flatUnwrap($0) }
    } else if let html = content as? any HTML {
        if let anyHTML = html as? AnyHTML {
            flatUnwrap([anyHTML.wrapped.body])
        } else if let collection = html as? HTMLCollection {
            flatUnwrap(collection.elements)
        } else {
            [html.body]
        }
    } else {
        []
    }
}

/// Recursively flattens nested `InlineHTML` content into a single array, unwrapping any body properties.
/// - Parameter content: The content to flatten and unwrap
/// - Returns: An array of unwrapped `InlineHTML` elements
@MainActor func flatUnwrap(_ content: Any) -> [any InlineElement] {
    if let array = content as? [Any] {
        array.flatMap { flatUnwrap($0) }
    } else if let html = content as? any InlineElement {
        if let anyHTML = html as? AnyHTML, let wrapped = anyHTML.wrapped.body as? (any InlineElement) {
            flatUnwrap([wrapped])
        } else if let collection = html as? HTMLCollection, let elements = collection.elements as? [any InlineElement] {
            flatUnwrap(elements)
        } else {
            [html]
        }
    } else {
        []
    }
}

/// Unwraps HTML content to its most basic form, collecting multiple elements into an HTMLCollection if needed.
/// - Parameter content: The content to unwrap
/// - Returns: A single HTML element or collection
@MainActor func unwrap(_ content: Any) -> any HTML {
    if let array = content as? [Any] {
        if let flattened = array.flatMap({ flatUnwrap($0) }) as? [any HTML] {
            return HTMLCollection(flattened)
        }
    } else if let html = content as? any HTML {
        if let anyHTML = html as? AnyHTML {
            return anyHTML.wrapped.body
        }
        return html.body
    }

    return EmptyHTML()
}
