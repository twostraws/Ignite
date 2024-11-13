//
// Group.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public struct Group: BlockElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }
    
    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic
    
    var items: any HTML
    private var isTransparent: Bool
    
    public init(@HTMLBuilder _ content: () -> some HTML) {
        self.items = content()
        self.isTransparent = false
    }
    
    public init(_ content: some HTML) {
        self.items = content
        self.isTransparent = false
    }
    
    public init(isTransparent: Bool, @HTMLBuilder content: () -> some HTML) {
        self.items = content()
        self.isTransparent = isTransparent
    }
    
    public init(_ items: any HTML, isTransparent: Bool = false) {
        self.items = items
        self.isTransparent = isTransparent
    }
    
    init(context: PublishingContext, items: [any HTML]) {
        self.items = FlatHTML(items)
        self.isTransparent = true
    }
    
    public func render(context: PublishingContext) -> String {
        if isTransparent {
            return items.render(context: context)
        } else {
            return "<div\(attributes.description)>\(items.render(context: context))</div>"
        }
    }
}
