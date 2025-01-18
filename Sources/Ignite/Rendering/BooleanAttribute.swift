//
// BooleanAttribute.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Ignite

/// A value-less attribute that can be enabled or disabled.
public struct BooleanAttribute: Hashable, Equatable, Sendable, Comparable {
    var name: String
    var isEnabled: Bool

    init(name: String, isEnabled: Bool = true) {
        self.name = name
        self.isEnabled = isEnabled
    }

    init(name: Property, isEnabled: Bool = true) {
        self.name = name.rawValue
        self.isEnabled = isEnabled
    }

    public static func < (lhs: BooleanAttribute, rhs: BooleanAttribute) -> Bool {
        lhs.name < rhs.name
    }

}
