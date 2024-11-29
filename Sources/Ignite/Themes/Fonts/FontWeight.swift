//
// FontWeight.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// The list of standard font weights supported by HTML. This
/// is designed to match the same order provided by SwiftUI.
/// Note: Bootstrap provides its own font weights as classes,
/// but these are less close to both regular CSS and SwiftUI.
public extension Font {
    enum Weight: Int, CaseIterable, Sendable {
        case ultraLight = 100
        case thin = 200
        case light = 300
        case regular = 400
        case medium = 500
        case semibold = 600
        case bold = 700
        case heavy = 800
        case black = 900
    }
}
