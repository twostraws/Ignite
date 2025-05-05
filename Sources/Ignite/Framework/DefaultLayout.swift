//
// DefaultLayout.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The layout you assigned to `Site`'s `layout` property.
public struct DefaultLayout: Layout {
    public var body: some Document {
        let layout = PublishingContext.shared.site.layout
        let head = layout.body.head
        let body = layout.body.body
        return PlainDocument(head: head, body: body)
    }
}
