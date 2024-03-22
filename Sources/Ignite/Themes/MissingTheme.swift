//
// MissingTheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A theme that does nothing at all. This is used as the default theme, so we can
/// detect that no theme has been applied to a page.
public struct MissingTheme: Theme {
    public func render(page: Page, context: PublishingContext) -> HTML {
        HTML { }
    }
}
