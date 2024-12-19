//
//  Markup-IsInsideList.swift
//  Ignite
//
//  Created by Paul Hudson on 19/12/2024.
//

import Markdown

extension Markup {
    /// A small helper that determines whether this markup or any parent is a list.
    var isInsideList: Bool {
        self is ListItemContainer || parent?.isInsideList == true
    }
}
