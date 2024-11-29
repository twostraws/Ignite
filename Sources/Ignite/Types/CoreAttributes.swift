//
// CoreAttributes.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import OrderedCollections

// A typealias that allows us to use OrderedSet without importing OrderedCollections
public typealias OrderedSet<Element: Hashable> = OrderedCollections.OrderedSet<Element>

/// A handful of attributes that all HTML types must support, either for
/// rendering or for publishing purposes.
public struct CoreAttributes: Sendable {
    /// A unique identifier. Can be empty.
    var id = ""

    /// ARIA attributes that add accessibility information.
    /// See https://www.w3.org/TR/html-aria/
    var aria = Set<AttributeValue>()

    /// CSS classes.
    var classes = OrderedSet<String>()

    /// Inline CSS styles.
    var styles = OrderedSet<AttributeValue>()

    /// Data attributes.
    var data = Set<AttributeValue>()

    /// JavaScript events, such as onclick.
    var events = Set<Event>()

    /// Custom attributes not covered by the above, e.g. loading="lazy"
    var customAttributes = Set<AttributeValue>()

    /// The HTML tag to use for this element, e.g. "div" or "p".
    var tag: String?

    /// An optional different tag to use when closing this element, e.g. "a" for links with href attributes.
    var closingTag: String?

    /// The tag to use for self-closing elements like "meta" or "img".
    var selfClosingTag: String?

    /// CSS classes that should be applied to a wrapper div around this element.
    /// Each `ContainerAttributes` represents a wrapper div with styling
    var containerAttributes = OrderedSet<ContainerAttributes>() {
        didSet {
            containerAttributes = OrderedSet(containerAttributes.sorted { a, b in
                // First handle transform vs animation containers
                if a.type == .transform && b.type == .animation {
                    return false // transform goes after animation
                }
                if a.type == .animation && b.type == .transform {
                    return true // animation goes before transform
                }

                // Click containers should always be outermost
                if a.type == .click {
                    return false // a goes after b
                }
                if b.type == .click {
                    return true // b goes after a
                }

                // For all other containers, maintain their relative positions
                return containerAttributes.firstIndex(of: a)! < containerAttributes.firstIndex(of: b)!
            })
        }
    }

    /// The ID of this element, if set.
    var idString: String {
        if id.isEmpty {
            ""
        } else {
            " id=\"\(id)\""
        }
    }

    /// All aria attributes for this element collapsed down to a string.
    var ariaString: String {
        if aria.isEmpty {
            return ""
        } else {
            var output = ""

            // Arium? Look, just give me this one…
            for arium in aria {
                output += " aria-\(arium.name)=\"\(arium.value)\""
            }

            return output
        }
    }

    /// All CSS classes for this element collapsed down to a string.
    var classString: String {
        if classes.isEmpty {
            return ""
        } else {
            return " class=\"\(classes.joined(separator: " "))\""
        }
    }

    /// All inline CSS styles for this element collapsed down to a string.
    var styleString: String {
        if styles.isEmpty {
            return ""
        } else {
            let stringified = styles.map { "\($0.name): \($0.value)" }.joined(separator: "; ")
            return " style=\"\(stringified)\""
        }
    }

    /// All data attributes for this element collapsed down to a string.
    var dataString: String {
        if data.isEmpty {
            return ""
        } else {
            var output = ""

            for datum in data {
                output += " data-\(datum.name)=\"\(datum.value)\""
            }

            return output
        }
    }

    /// All events for this element, collapsed to down to a string.
    var eventString: String {
        var result = ""

        for event in events where event.actions.isEmpty == false {
            let actions = event.actions.map { $0.compile() }.joined(separator: "; ")

            result += " \(event.name)=\"\(actions)\""
        }

        return result
    }

    /// All custom attributes for this element collapsed down to a string.
    var customAttributeString: String {
        if customAttributes.isEmpty {
            return ""
        } else {
            var output = ""

            for attribute in customAttributes {
                output += " \(attribute.name)=\"\(attribute.value)\""
            }

            return output
        }
    }
    
    /// Generates an HTML string containing all attributes and optionally wraps content.
    /// - Parameter content: Optional content to wrap with opening and closing tags
    /// - Returns: A string containing all attributes and optional content wrapped in tags
    func description(wrapping content: String? = nil) -> String {
        let attributes = "\(idString)\(customAttributeString)\(classString)\(styleString)\(dataString)\(ariaString)\(eventString)"

        var result = content ?? attributes

        if containerAttributes.isEmpty {
            if let selfClosingTag {
                return "<\(selfClosingTag)\(attributes) />"
            }
            if let tag {
                let closing = closingTag ?? tag
                return "<\(tag)\(attributes)>\(content ?? "")</\(closing)>"
            }
            return result
        }

        if let selfClosingTag {
            result = "<\(selfClosingTag)\(attributes) />"
        } else if let tag {
            let closing = closingTag ?? tag
            result = "<\(tag)\(attributes)>\(result)</\(closing)>"
        }

        // Apply containers from inner to outer
        for container in containerAttributes where !container.isEmpty {
            let classAttr = container.classes.isEmpty ? "" : " class=\"\(container.classes.joined(separator: " "))\""
            let styleAttr = container.styles.isEmpty ? "" : " style=\"\(container.styles.map { "\($0.name): \($0.value)" }.joined(separator: "; "))\""

            var eventAttr = ""
            for event in container.events where event.actions.isEmpty == false {
                let actions = event.actions.map { $0.compile() }.joined(separator: "; ")
                eventAttr += " \(event.name)=\"\(actions)\""
            }

            result = "<div\(classAttr)\(styleAttr)\(eventAttr)>\(result)</div>"
        }

        return result
    }

    /// Appends an array of CSS classes to the current element.
    /// - Parameter classes: The CSS classes to append.
    mutating func append(classes: [String]) {
        self.classes.formUnion(classes)
    }

    /// Appends multiple CSS classes to the current element.
    /// - Parameter classes: The CSS classes to append.
    mutating func append(classes: String...) {
        self.classes.formUnion(classes)
    }

    /// Returns a new set of attributes with extra CSS classes appended.
    /// - Parameter classes: The CSS classes to append.
    /// - Returns: A copy of the previous `CoreAttributes` object with
    /// the extra CSS classes applied.
    func appending(classes: [String]) -> CoreAttributes {
        var copy = self
        copy.classes.formUnion(classes)
        return copy
    }

    /// Appends a class to the elements container.
    /// - Parameter dataAttributes: Variable number of container attributes to append.
    mutating func append(containerAttributes: ContainerAttributes...) {
        self.containerAttributes.formUnion(containerAttributes)
    }

    /// Appends a class to the elements container.
    /// - Parameter dataAttributes: The container attributes to append.
    mutating func append(containerAttributes: [ContainerAttributes]) {
        self.containerAttributes.formUnion(containerAttributes)
    }

    /// Returns a new set of attributes with an extra aria appended
    /// - Parameter aria: The aria to append
    /// - Returns: A copy of the previous `CoreAttributes` object with
    /// the extra aria applied.
    func appending(aria: AttributeValue?) -> CoreAttributes {
        guard let aria else {
            return self
        }
        var copy = self
        copy.aria.insert(aria)
        return copy
    }

    /// Appends multiple extra inline CSS styles.
    /// - Parameter classes: The inline CSS styles to append.
    mutating func append(styles: AttributeValue...) {
        self.styles.formUnion(styles)
    }

    /// Appends a single extra inline CSS style.
    ///  - Parameter style: The style name, e.g. background-color
    ///  - Parameter value: The style value, e.g. steelblue
    mutating func append(style: String, value: String) {
        styles.append(AttributeValue(name: style, value: value))
    }

    /// Appends a data attribute to the element.
    /// - Parameter dataAttributes: Variable number of data attributes to append.
    mutating func append(dataAttributes: AttributeValue...) {
        data.formUnion(dataAttributes)
    }

    /// Appends multiple custom attributes to the element.
    /// - Parameter customAttributes: Variable number of custom attributes to append,
    ///   where each attribute is an `AttributeValue` containing a name-value pair.
    mutating func append(customAttributes: AttributeValue...) {
        self.customAttributes.formUnion(customAttributes)
    }

    /// Appends an array of inline CSS styles to the element.
    /// - Parameter newStyles: An array of `AttributeValue` objects representing
    ///   CSS style properties and their values to be added.
    mutating func append(styles newStyles: [AttributeValue]) {
        var styles = self.styles
        styles.formUnion(newStyles)
        self.styles = styles
    }
}
