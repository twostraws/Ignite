//
// GridItemSizing.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public enum GridItemSizing: Sendable {
    case automatic
    case adaptive(minimum: LengthUnit)

    public static func adaptive(minimum: Int) -> Self {
        .adaptive(minimum: .px(minimum))
    }

    var inlineStyles: [InlineStyle] {
        switch self {
        case .automatic: []
        case .adaptive(let minimum): [.init("--ig-grid-item-min-width", value: minimum.stringValue)]
        }
    }
}
