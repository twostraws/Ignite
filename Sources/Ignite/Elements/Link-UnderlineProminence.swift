//
// Link-UnderlineProminence.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension Link {
    /// Defines the prominence of the underline decoration for links,
    /// allowing customization of both base and hover styles.
    public enum UnderlineProminence: Equatable {

        /// No underline style with an opacity of 0%.
        case none

        /// A faint underline style with an opacity of 10%.
        case faint

        /// A light underline style with an opacity of 25%.
        case light

        /// A medium underline style with an opacity of 50%.
        case medium

        /// A bold underline style with an opacity of 75%.
        case bold

        /// A fully opaque underline style with an opacity of 100%.
        case heavy

        /// The opacity value as an `Int`, representing the opacity percentage.
        var opacity: Int {
            switch self {
            case .none:
                0
            case .faint:
                10
            case .light:
                25
            case .medium:
                50
            case .bold:
                75
            case .heavy:
                100
            }
        }
    }
}
