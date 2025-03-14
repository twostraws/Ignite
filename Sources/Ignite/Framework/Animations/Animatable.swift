//
// Animatable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import OrderedCollections

/// A protocol that defines the core animation capabilities for Ignite's animation system.
protocol Animatable: Hashable, Sendable {}

extension Animatable {
    var id: String {
        Self.id
    }

    static var id: String {
        String(describing: self).truncatedHash
    }
}
