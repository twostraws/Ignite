//
// Component.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A type that provides a reusable part of a page, e.g. a common header or footer.
public protocol Component: PageElement {
    /// Provides the content of this body, using a page element builder to provide
    /// an array of page elements to include in the component.
    /// - Parameter context: The current publishing context.
    /// - Returns: An array of page elements to include in the component.
    @PageElementBuilder func body(context: PublishingContext) -> [PageElement]
}

extension Component {
    public var attributes: CoreAttributes {
        get { CoreAttributes() }
        set { }
    }

    /// A default method that knows how to render this component to HTML.
    public func render(context: PublishingContext) -> String {
        let items = body(context: context)
        return items.render(into: self, context: context)
    }
}
