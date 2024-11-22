//
// InlineElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// An element that handles list rendering by placing its <li> tag manually.
@MainActor
protocol ListableElement {
    /// Render this when we know for sure we're part of a List.
    func renderInList(context: PublishingContext) -> String
}
