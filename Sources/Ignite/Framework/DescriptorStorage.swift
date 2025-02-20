//
// AttributeStorage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Manages the storage and merging of HTML element attributes throughout the application
public final class DescriptorStorage {
    /// Shared singleton instance for global access
    @MainActor static let shared = DescriptorStorage()

    /// Storage dictionary mapping element IDs to their core attributes
    private var storage: [String: ElementDescriptor] = [:]

    /// Retrieves the core attributes for a given element ID
    /// - Parameter elementID: The unique identifier of the HTML element
    /// - Returns: The core attributes for the element, or new empty attributes if none exist
    func descriptor(for elementID: String) -> ElementDescriptor {
        storage[elementID] ?? ElementDescriptor()
    }

    /// Merges new attributes with existing ones for a specific HTML element
    /// - Parameters:
    ///   - attributes: The new attributes to merge
    ///   - id: The unique identifier of the HTML element
    ///   - removedStyles: Optional array of styles to remove after merging
    ///   - removedClasses: Optional array of classes to remove after merging
    private func mergeDescriptor(
        _ descriptor: ElementDescriptor,
        intoHTML id: String,
        removedStyles: [InlineStyle]? = nil,
        removedClasses: [String]? = nil
    ) -> ElementDescriptor {
        let currentDescriptor = storage[id] ?? ElementDescriptor()
        var mergedDescriptor = currentDescriptor

        mergedDescriptor.styles.formUnion(descriptor.styles)
        mergedDescriptor.classes.formUnion(descriptor.classes)
        mergedDescriptor.aria.formUnion(descriptor.aria)
        mergedDescriptor.data.formUnion(descriptor.data)
        mergedDescriptor.events.formUnion(descriptor.events)
        mergedDescriptor.containerAttributes.formUnion(descriptor.containerAttributes)
        mergedDescriptor.customAttributes.formUnion(descriptor.customAttributes)

        if descriptor.columnWidth != .automatic {
            mergedDescriptor.columnWidth = descriptor.columnWidth
        }

        if descriptor.id.isEmpty == false {
            mergedDescriptor.id = descriptor.id
        }

        if descriptor.tag != nil {
            mergedDescriptor.tag = descriptor.tag
        }

        if descriptor.closingTag != nil {
            mergedDescriptor.closingTag = descriptor.closingTag
        }

        if descriptor.selfClosingTag != nil {
            mergedDescriptor.selfClosingTag = descriptor.selfClosingTag
        }

        removedStyles?.forEach { mergedDescriptor.styles.remove($0) }
        removedClasses?.forEach { mergedDescriptor.classes.remove($0) }

        return mergedDescriptor
    }

    /// Merges new attributes with existing ones for a specific HTML element
    /// - Parameters:
    ///   - attributes: The new attributes to merge
    ///   - id: The unique identifier of the HTML element
    func merge(_ descriptor: ElementDescriptor, intoHTML id: String) {
        storage[id] = mergeDescriptor(descriptor, intoHTML: id)
    }

    /// Merges new attributes with existing ones for a specific HTML element, then removes specified styles
    /// - Parameters:
    ///   - attributes: The new attributes to merge
    ///   - id: The unique identifier of the HTML element
    ///   - styles: Array of styles to remove after merging
    func merge(_ descriptor: ElementDescriptor, intoHTML id: String, removing styles: some Collection<InlineStyle>) {
        storage[id] = mergeDescriptor(descriptor, intoHTML: id, removedStyles: Array(styles))
    }

    /// Merges new attributes with existing ones for a specific HTML element, then removes specified classes
    /// - Parameters:
    ///   - attributes: The new attributes to merge
    ///   - id: The unique identifier of the HTML element
    ///   - classes: Array of classes to remove after merging
    func merge(_ descriptor: ElementDescriptor, intoHTML id: String, removing classes: some Collection<String>) {
        storage[id] = mergeDescriptor(descriptor, intoHTML: id, removedClasses: Array(classes))
    }
}
