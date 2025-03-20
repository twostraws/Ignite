//
//  Container.swift
//  Ignite
//
//  Created by Joshua Toro on 3/19/25.
//

struct Container: HTML {
    /// The content and behavior of this HTML.
    var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    var isPrimitive: Bool { true }

    var wrapped: any HTML

    /// Creates a container that renders as a `div` element.
    /// - Parameter content: The content to display within this section.
    init(_ content: any HTML) {
        guard let anyHTML = content as? AnyHTML else {
            self.wrapped = content
            return
        }

        self.wrapped = anyHTML.attributedContent
    }

    func render() -> String {
        return "<div\(attributes)>\(wrapped)</div>"
    }
}
