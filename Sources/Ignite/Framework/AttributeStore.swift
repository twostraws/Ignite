//
// AttributeStorage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Manages the storage and merging of HTML element attributes throughout the application
public class AttributeStore {
    /// Shared singleton instance for global access
    @MainActor static let `default` = AttributeStore()

    /// Storage dictionary mapping element IDs to their core attributes
    var storage: [String: CoreAttributes] = [:]

    /// Retrieves the core attributes for a given element ID
    /// - Parameter elementID: The unique identifier of the HTML element
    /// - Returns: The core attributes for the element, or new empty attributes if none exist
    func attributes(for elementID: String) -> CoreAttributes {
        return storage[elementID] ?? CoreAttributes()
    }

    /// Merges new attributes with existing ones for a specific HTML element
    /// - Parameters:
    ///   - attributes: The new attributes to merge
    ///   - id: The unique identifier of the HTML element
    ///   - removedStyles: Optional array of styles to remove after merging
    ///   - removedClasses: Optional array of classes to remove after merging
    private func mergeAttributes(
        _ attributes: CoreAttributes,
        intoHTML id: String,
        removedStyles: [AttributeValue]? = nil,
        removedClasses: [String]? = nil
    ) -> CoreAttributes {
        let currentAttributes = storage[id] ?? CoreAttributes()
        var mergedAttributes = currentAttributes

        mergedAttributes.styles.formUnion(attributes.styles)
        mergedAttributes.classes.formUnion(attributes.classes)
        mergedAttributes.aria.formUnion(attributes.aria)
        mergedAttributes.data.formUnion(attributes.data)
        mergedAttributes.events.formUnion(attributes.events)
        mergedAttributes.containerAttributes.formUnion(attributes.containerAttributes)
        mergedAttributes.customAttributes.formUnion(attributes.customAttributes)
        mergedAttributes.id = attributes.id

        if attributes.tag != nil {
            mergedAttributes.tag = attributes.tag
        }
        if attributes.closingTag != nil {
            mergedAttributes.closingTag = attributes.closingTag
        }
        if attributes.selfClosingTag != nil {
            mergedAttributes.selfClosingTag = attributes.selfClosingTag
        }

        removedStyles?.forEach { mergedAttributes.styles.remove($0) }
        removedClasses?.forEach { mergedAttributes.classes.remove($0) }

        return mergedAttributes
    }

    /// Merges new attributes with existing ones for a specific HTML element
    /// - Parameters:
    ///   - attributes: The new attributes to merge
    ///   - id: The unique identifier of the HTML element
    func merge(_ attributes: CoreAttributes, intoHTML id: String) {
        storage[id] = mergeAttributes(attributes, intoHTML: id)
    }

    /// Merges new attributes with existing ones for a specific HTML element, then removes specified styles
    /// - Parameters:
    ///   - attributes: The new attributes to merge
    ///   - id: The unique identifier of the HTML element
    ///   - styles: Array of styles to remove after merging
    func merge(_ attributes: CoreAttributes, intoHTML id: String, removing styles: some Collection<AttributeValue>) {
        storage[id] = mergeAttributes(attributes, intoHTML: id, removedStyles: Array(styles))
    }

    /// Merges new attributes with existing ones for a specific HTML element, then removes specified classes
    /// - Parameters:
    ///   - attributes: The new attributes to merge
    ///   - id: The unique identifier of the HTML element
    ///   - classes: Array of classes to remove after merging
    func merge(_ attributes: CoreAttributes, intoHTML id: String, removing classes: some Collection<String>) {
        storage[id] = mergeAttributes(attributes, intoHTML: id, removedClasses: Array(classes))
    }
}
