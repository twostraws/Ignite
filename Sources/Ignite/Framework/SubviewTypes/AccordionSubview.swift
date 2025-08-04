//
// AccordionSubview.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An opaque HTML element representing a subview of an `Accordion`.
struct AccordionSubview: HTML {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The underlying HTML content, unattributed.
    private var content: any AccordionElement

    /// The underlying HTML content, with attributes.
    var wrapped: any AccordionElement {
        var wrapped = content
        wrapped.attributes.merge(attributes)
        return wrapped
    }

    /// Creates a new `AccordionSubview` instance that wraps the given element.
    /// - Parameter wrapped: The element to wrap
    init(_ wrapped: any AccordionElement) {
        self.content = wrapped
    }

    nonisolated func render() -> Markup {
        MainActor.assumeIsolated {
           wrapped.render()
        }
    }
}

extension AccordionSubview: Equatable {
    nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.render() == rhs.render()
    }
}

extension AccordionSubview: AccordionItemAssignable {
    func assigned(to parentID: String, openMode: AccordionOpenMode) -> Self {
        if let wrapped = wrapped as? any AccordionItemAssignable {
            AccordionSubview(wrapped.assigned(to: parentID, openMode: openMode))
        } else {
           self
        }
    }
}
