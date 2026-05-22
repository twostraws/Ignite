//
// PublishingRegistration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A publishing-time registration required by rendered attributes.
enum PublishingRegistration: Hashable, Equatable, Sendable {
    case fontFamily(Font)
    case responsiveFont(ResponsiveValues<LengthUnit>)
    case responsiveVisibility(ResponsiveValues<Bool>)

    func apply(to context: PublishingContext) {
        switch self {
        case .fontFamily(let font):
            context.cssManager.registerFontFamily(font)
        case .responsiveFont(let values):
            _ = context.cssManager.registerFont(values)
        case .responsiveVisibility(let values):
            _ = context.cssManager.registerStyles(values)
        }
    }
}
