//
// CoreAttributes.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A handful of attributes that all HTML types must support, either for
/// rendering or for publishing purposes.
public struct CoreAttributes {
    /// A unique identifier. Can be empty.
    var id = ""

    /// ARIA attributes that add accessibility information.
    /// See https://www.w3.org/TR/html-aria/
    var aria = [AttributeValue]()

    /// CSS classes.
    var classes = [String]()

    /// Inline CSS styles.
    var styles = [String]()

    /// data- attributes.
    var data = [AttributeValue]()

    /// JavaScript events, such as onclick.
    var events = [Event]()

    /// Custom attributes not covered by the above, e.g. loading="lazy"
    var customAttributes = [AttributeValue]()

    /// All core attributes collapsed down to a single string for easy application.
    var description: String {
        "\(idString)\(customAttributeString)\(classString)\(styleString)\(dataString)\(ariaString)\(eventString)"
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
            ""
        } else {
            " style=\"\(styles.joined(separator: "; "))\""
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

        for event in events {
            if event.actions.isEmpty == false {
                let actions = event.actions.map { $0.compile() }.joined(separator: "; ")

                result += " \(event.name)=\"\(actions)\""
            }
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

    /// Appends an array of CSS classes to the current element.
    /// - Parameter classes: The CSS classes to append.
    mutating func append(classes: [String]) {
        self.classes.append(contentsOf: classes)
    }

    /// Returns a new set of attributes with extra CSS classes appended.
    /// - Parameter classes: The CSS classes to append.
    /// - Returns: A copy of the previous `CoreAttributes` object with
    /// the extra CSS classes applied.
    func appending(classes: [String]) -> CoreAttributes {
        var copy = self
        copy.classes.append(contentsOf: classes)
        return copy
    }

    /// Returns a new set of attributes with extra inline CSS styles appended.
    /// - Parameter classes: The inline CSS styles to append.
    /// - Returns: A copy of the previous `CoreAttributes` object with
    /// the extra inline CSS styles applied.
    mutating func append(styles: String...) {
        self.styles.append(contentsOf: styles)
    }
}
