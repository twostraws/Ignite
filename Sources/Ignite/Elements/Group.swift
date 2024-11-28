//
// Group.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public struct Group: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }
    
    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash
    
    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }
    
    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic
    
    var items: [any HTML] = []
    private var isTransparent: Bool
    
    public init(@HTMLBuilder _ content: () -> some HTML) {
        let content: [any HTML] = flatUnwrap(content())
        self.isTransparent = false
        let items = content.map {
            if let anyHTML = $0 as? AnyHTML {
                return anyHTML.unwrapped.body
            }
            return $0.body
        }
        self.items = items
    }
    
    public init(_ content: some HTML) {
        self.items = flatUnwrap(content)
        self.isTransparent = false
    }
    
    public init(isTransparent: Bool, @HTMLBuilder content: () -> some HTML) {
        self.items = flatUnwrap(content())
        self.isTransparent = isTransparent
    }
    
    public init(_ items: any HTML, isTransparent: Bool = false) {
        self.items = flatUnwrap(items)
        self.isTransparent = isTransparent
    }
    
    init(context: PublishingContext, items: [any HTML]) {
        self.items = flatUnwrap(items)
        self.isTransparent = true
    }
    
    public func render(context: PublishingContext) -> String {
        let content = items.map { $0.render(context: context) }.joined()
        if isTransparent {
            return content
        } else {
            var attributes = attributes
            attributes.tag = "div"
            return attributes.description(wrapping: content)
        }
    }
}
