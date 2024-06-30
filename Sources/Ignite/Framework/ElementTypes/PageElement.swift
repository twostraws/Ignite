//
// PageElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A user-visible element that can appear anywhere on a page, block or otherwise.
public protocol PageElement: BaseElement {
    /// The standard set of control attributes for HTML elements.
    var attributes: CoreAttributes { get set }
}

extension PageElement {
    /// Adds new classes to this element.
    /// - Parameter newClasses: One or more classes to add to this
    /// element. Specifying nil ignores the class, which is helpful for ternary
    /// conditional operators.
    /// - Returns: A copy of the current element with the new classes applied.
    public func `class`(_ newClasses: String?...) -> Self {
        let compacted = newClasses.compactMap { $0 }
        return self.class(compacted)
    }

    /// Adds new classes to this element.
    /// - Parameter newClasses: Zero or more classes to add to this
    /// element. This is a helpful alternative for when the variadic option is
    /// not possible.
    /// - Returns: A copy of the current element with the new classes applied.
    public func `class`(_ newClasses: [String]) -> Self {
        var copy = self

        // Refuse to add class names more than once.
        for case let newClass? in newClasses where copy.attributes.classes.contains(newClass) == false {
            // Empty class names are to be ignored.
            if newClass.isEmpty { continue }
            copy.attributes.classes.append(newClass)
        }

        return copy
    }

    /// Adds a "data-" attribute to this element.
    /// - Parameters:
    ///   - name: The name of the attribute to add, without the "data-" prefix.
    ///   - value: The value for the attribute.
    /// - Returns: A copy of the current element with the attribute added.
    public func data(_ name: String, _ value: String?) -> Self {
        guard let value else { return self }
        let attribute = AttributeValue(name: name, value: value)
        var copy = self
        copy.attributes.data.append(attribute)

        return copy
    }

    /// Adds an "aria-" attribute to this element.
    /// - Parameters:
    ///   - name: The name of the attribute to add, without the "aria-" prefix.
    ///   - value: The value for the attribute.
    /// - Returns: A copy of the current element with the attribute added.
    public func aria(_ key: String, _ value: String?) -> Self {
        if let value {
            let attribute = AttributeValue(name: key, value: value)
            var copy = self
            copy.attributes.aria.append(attribute)
            return copy
        } else {
            return self
        }
    }

    /// Adds one or more CSS styles to this element.
    /// - Parameter values: Values specified as complete CSS styles, e.g. "margin: 5px".
    /// - Returns: A copy of the current element with the new styles applied.
    public func style(_ values: String...) -> Self {
        var copy = self
        copy.attributes.styles.append(contentsOf: values)
        return copy
    }

    /// Sets the "id" attribute for this element.
    /// - Parameter string: The unique identifier for this attribute.
    /// - Returns: A copy of the current element with the new ID applied.
    public func id(_ string: String) -> Self {
        var copy = self
        copy.attributes.id = string
        return copy
    }

    public mutating func addEvent(name: String, actions: [Action]) {
        guard actions.isEmpty == false else { return }
        let event = Event(name: name, actions: actions)
        self.attributes.events.append(event)
    }

    public func addingEvent(name: String, actions: [any Action]) -> Self {
        var copy = self
        copy.addEvent(name: name, actions: actions)
        return copy
    }

    /// Adds a custom attribute to this element, e.g. loading="lazy".
    /// - Parameters:
    ///   - name: The name of the custom attribute to add.
    ///   - value: The attribute's value.
    /// - Returns: A copy of the current element with the new attribute applied.
    public func addCustomAttribute(name: String, value: String) -> Self {
        let value = AttributeValue(name: name, value: value)
        var copy = self
        copy.attributes.customAttributes.append(value)
        return copy
    }

    /// Copies all core attributes across; used when higher-order elements
    /// need to render down to simpler ones, e.g. Carousel -> Group.
    /// **Important:** This must be used before any other modifiers when rendering to avoid losing attributes.
    public func attributes(_ attributes: CoreAttributes) -> Self {
        var copy = self
        copy.attributes = attributes
        return copy
    }

    /// Sets the tab focus (a.k.a tabindex) of this element.
    /// **Important:** Use this with caution as it is easy to make mistakes and cause problems with screen readers.
    /// - Parameter tabFocus: The desired `TabFocus` enum value
    /// - Returns: A copy of the current element with the tap focus applied.
    public func tabFocus(_ tabFocus: TabFocus) -> Self {
        addCustomAttribute(name: tabFocus.htmlName, value: tabFocus.value)
    }
}
