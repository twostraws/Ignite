//
// Subview.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An opaque value representing the child of another view.
struct Subview: HTML {
    /// The content and behavior of this HTML.
    var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The underlying HTML content, unattributed.
    private var content: any HTML

    /// The underlying HTML content, with attributes.
    var wrapped: any HTML {
        var wrapped = content
        wrapped.attributes.merge(attributes)
        return wrapped
    }

    /// Creates a new `Subview` instance that wraps the given HTML content.
    /// - Parameter content: The HTML content to wrap
    init(_ wrapped: any HTML) {
        self.content = wrapped
    }

    nonisolated func render() -> Markup {
        MainActor.assumeIsolated {
           wrapped.render()
        }
    }
}

extension Subview: Equatable {
    nonisolated static func == (lhs: Subview, rhs: Subview) -> Bool {
        lhs.render() == rhs.render()
    }
}

extension Subview {
    func configuredAsCardComponent() -> CardComponent {
        /// Returns the wrapped element, configured for display
        /// within in a `Card`, in an opaque wrapper.
        if let wrapped = wrapped as? any CardComponentConfigurable {
            return wrapped.configuredAsCardComponent()
        }
        return CardComponent(self)
    }
}
