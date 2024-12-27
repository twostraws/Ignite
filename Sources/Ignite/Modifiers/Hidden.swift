//
// Hidden.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that controls element visibility
struct HiddenModifier: HTMLModifier {
    /// Whether the element should be hidden
    private let isHidden: Bool

    /// Media queries that determine when the element should be hidden
    private let queries: [MediaQuery]?

    /// Creates a new hidden modifier with a boolean flag
    /// - Parameter isHidden: Whether to hide the element
    init(isHidden: Bool = true) {
        self.isHidden = isHidden
        self.queries = nil
    }

    /// Creates a new hidden modifier with media queries
    /// - Parameter queries: Media queries that determine when to hide the element
    init(queries: [MediaQuery]) {
        self.isHidden = true
        self.queries = queries

        // Register the media query conditions to get a reusable class name
        if !queries.isEmpty {
            CSSManager.default.register(queries)
        }
    }

    /// Applies visibility styling to the provided HTML content
    func body(content: some HTML) -> any HTML {
        if let queries, !queries.isEmpty {
            let hash = CSSManager.default.hashForQueries(queries)
            let className = "style-\(hash)"
            CSSManager.default.register(queries)
            return content.class(className)
        } else {
            return content.class(isHidden ? "d-none" : nil)
        }
    }
}

public extension HTML {
    /// Optionally hides the view in the view hierarchy.
    /// - Parameter isHidden: Whether to hide this element or not.
    /// - Returns: A modified copy of the element with visibility applied.
    func hidden(_ isHidden: Bool = true) -> some HTML {
        modifier(HiddenModifier(isHidden: isHidden))
    }

    /// Hides the element when all specified media queries match.
    /// - Parameter queries: One or more media queries that must all match for the element to be hidden.
    /// - Returns: A modified copy of the element with conditional visibility.
    func hidden(_ queries: MediaQuery...) -> some HTML {
        modifier(HiddenModifier(queries: queries))
    }
}
