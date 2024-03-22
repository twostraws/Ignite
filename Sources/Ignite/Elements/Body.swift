//
// Body.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// The main, user-visible contents of your page.
public struct Body: PageElement, HTMLRootElement {
    public var attributes = CoreAttributes()

    var items: [BaseElement]

    public init(@ElementBuilder<BaseElement> _ items: () -> [BaseElement]) {
        self.items = items()
    }

    public init(for page: Page) {
        self.items = [page.body]
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        let output = Group {
            for item in items {
                item
            }
        }
        .class("col-sm-\(context.site.pageWidth)", "mx-auto")
        .render(context: context)

        return "<body\(attributes.description)>\(output)</body>"
    }
}
