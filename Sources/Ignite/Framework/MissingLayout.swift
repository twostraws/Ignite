//
// MissingTheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A layout that does nothing at all. This is used as the default layout, so we can
/// detect that no layout has been applied to a page.
public struct MissingLayout: Layout {
    public var body: HTMLDocument {
        HTMLDocument {}
    }
}
