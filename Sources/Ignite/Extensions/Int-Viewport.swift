//
// Int-Viewport.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Returns a special value indicating that a dimension should use 100% of the viewport size
public extension Int {
    static var viewport: Int { .max }
}
