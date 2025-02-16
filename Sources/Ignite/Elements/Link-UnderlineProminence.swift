//
// Link-UnderlineProminence.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public extension Link {
    /// Defines the prominence of the underline decoration for links,
    /// allowing customization of both base and hover styles.
    enum UnderlineProminence: Int, CustomStringConvertible, Equatable {
        /// No underline style with an opacity of 0%.
        case none = 0
        /// A faint underline style with an opacity of 10%.
        case faint = 10
        /// A light underline style with an opacity of 25%.
        case light = 25
        /// A medium underline style with an opacity of 50%.
        case medium = 50
        /// A bold underline style with an opacity of 75%.
        case bold = 75
        /// A fully opaque underline style with an opacity of 100%.
        case heavy = 100

        /// The Bootstrap opacity suffix.
        public var description: String {
            rawValue.formatted()
        }
    }
}
