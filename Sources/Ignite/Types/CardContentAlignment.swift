//
// CardContentAlignment.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public enum CardContentAlignment: CaseIterable, Sendable {
    case topLeading
    case top
    case topTrailing
    case leading
    case center
    case trailing
    case bottomLeading
    case bottom
    case bottomTrailing

    enum TextAlignment: String, CaseIterable, Sendable {
        case start = "text-start"
        case center = "text-center"
        case end = "text-end"
    }

    enum VerticalAlignment: String, CaseIterable, Sendable {
        case start = "align-content-start"
        case center = "align-content-center"
        case end = "align-content-end"
    }

    var textAlignment: TextAlignment {
        switch self {
        case .topLeading, .leading, .bottomLeading:
            .start
        case .top, .center, .bottom:
            .center
        case .topTrailing, .trailing, .bottomTrailing:
            .end
        }
    }

    var verticalAlignment: VerticalAlignment {
        switch self {
        case .topLeading, .top, .topTrailing:
            .start
        case .leading, .center, .trailing:
            .center
        case .bottomLeading, .bottom, .bottomTrailing:
            .end
        }
    }

    public static let `default` = Self.topLeading
}
