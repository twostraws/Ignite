//
// CarouselSubview.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An opaque HTML element representing a subview of an `Carousel`.
struct CarouselSubview: HTML {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The underlying HTML content, unattributed.
    private var content: any CarouselElement

    /// The underlying HTML content, with attributes.
    var wrapped: any CarouselElement {
        var wrapped = content
        wrapped.attributes.merge(attributes)
        return wrapped
    }

    /// Creates a new `CarouselSubview` instance that wraps the element.
    /// - Parameter wrapped: The element to wrap
    init(_ wrapped: any CarouselElement) {
        self.content = wrapped
    }

    nonisolated func render() -> Markup {
        MainActor.assumeIsolated {
            wrapped.render()
        }
    }
}

extension CarouselSubview: Equatable {
    nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.render() == rhs.render()
    }
}
