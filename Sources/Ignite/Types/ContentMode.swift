//
// ContentMode.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The content mode of an element, e.g. an image, within its container.
public enum ContentMode: CaseIterable, Sendable {
    /// The element is sized to fit into the container.
    case fit

    /// The element is sized to fill the container, possibly cutting of parts of the element.
    case fill

    var htmlClass: String {
        "object-fit-\(self == .fill ? "cover" : "contain")"
    }
}
