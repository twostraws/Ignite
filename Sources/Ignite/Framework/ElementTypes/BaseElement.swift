//
// BaseElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Describes any element that can be rendered to HTML.
public protocol BaseElement {
    func render(context: PublishingContext) -> String
}
