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
    func merge(_ attributes: CoreAttributes, intoHTML id: String) {
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
         
        storage[id] = mergedAttributes
    }
}
