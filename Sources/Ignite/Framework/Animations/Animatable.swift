//
// Animatable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import OrderedCollections

/// A protocol that defines the core animation capabilities for Ignite's animation system.
protocol Animatable: Hashable, Sendable {
    /// A unique identifier generated from the animation type name
    static var id: String { get }
}

extension Animatable {
    var id: String {
        Self.id
    }

    static var id: String {
        String(describing: self).truncatedHash
    }
}
