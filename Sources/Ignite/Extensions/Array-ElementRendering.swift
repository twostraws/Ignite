//
// Array-ElementRendering.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension Array where Element == any PageElement {
    /// An extension that makes it easier to render arrays of `PageElement`
    /// objects to a HTML string.
    func render(context: PublishingContext) -> String {
        map { $0.render(context: context) }.joined()
    }
}

extension Array where Element == any HeadElement {
    /// An extension that makes it easier to render arrays of `HeadElement`
    /// objects to a HTML string.
    func render(context: PublishingContext) -> String {
        map { $0.render(context: context) }.joined()
    }
}

extension Array where Element == any BlockElement {
    /// An extension that makes it easier to render arrays of `BlockElement`
    /// objects to a HTML string.
    public func render(context: PublishingContext) -> String {
        map { $0.render(context: context) }.joined()
    }
}

extension Array where Element == any InlineElement {
    /// An extension that makes it easier to render arrays of `InlineElement`
    /// objects to a HTML string.
    func render(context: PublishingContext) -> String {
        map { $0.render(context: context) }.joined()
    }
}

extension Array where Element == any BaseElement {
    /// An extension that makes it easier to render arrays of `BaseElement`
    /// objects to a HTML string.
    func render(context: PublishingContext) -> String {
        map { $0.render(context: context) }.joined()
    }
}
