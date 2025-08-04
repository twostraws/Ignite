//
// CardContentPosition.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Where to position the content of the card relative to it image.
public enum CardContentPosition: CaseIterable, Sendable {
    public static let allCases: [CardContentPosition] = [
        .bottom, .top, .overlay(alignment: .topLeading)
    ]

    /// Positions content below the image.
    case bottom

    /// Positions content above the image.
    case top

    /// Positions content over the image.
    case overlay(alignment: CardContentAlignment)

    // Static entries for backward compatibilty
    public static let `default` = Self.bottom
    public static let overlay = Self.overlay(alignment: .topLeading)

    // MARK: Helpers for `render`

    var imageClass: String {
        switch self {
        case .bottom:
            "card-img-top"
        case .top:
            "card-img-bottom"
        case .overlay:
            "card-img"
        }
    }

    var bodyClasses: [String] {
        switch self {
        case .overlay(let alignment):
            ["card-img-overlay", alignment.textAlignment.rawValue, alignment.verticalAlignment.rawValue]
        default:
            ["card-body"]
        }
    }

    var addImageFirst: Bool {
        switch self {
        case .bottom, .overlay:
            true
        case .top:
            false
        }
    }
}
