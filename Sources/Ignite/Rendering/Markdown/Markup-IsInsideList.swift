//
// Padding.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Markdown

extension Markup {
    /// A small helper that determines whether this markup or any parent is a list.
    var isInsideList: Bool {
        self is ListItemContainer || parent?.isInsideList == true
    }
}
