//
// TagPage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Tag pages show all articles on your site that match a specific tag,
/// or all articles period if `tag` is nil. You get to decide what is shown
/// on those pages by making a custom type that conforms to this protocol.
public protocol TagPage: ThemedPage {
    @BlockElementBuilder func body(tag: String?, context: PublishingContext) -> [BlockElement]
}
