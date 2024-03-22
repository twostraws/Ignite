//
// EmptyTheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A theme that applies almost no styling.
public struct EmptyTheme: Theme {
    public init() { }

    public func render(page: Page, context: PublishingContext) -> HTML {
        HTML {
            Body(for: page)
        }
    }
}
