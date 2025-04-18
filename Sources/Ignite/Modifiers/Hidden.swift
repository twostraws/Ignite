//
// Hidden.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Optionally hides the view in the view hierarchy.
    /// - Parameter isHidden: Whether to hide this element or not.
    /// - Returns: A modified copy of the element with visibility applied.
    func hidden(_ isHidden: Bool = true) -> some HTML {
        AnyHTML(hiddenModifier(isHidden))
    }

    /// Hides the element when all specified media queries match.
    /// - Parameter queries: One or more media queries that must all match for the element to be hidden.
    /// - Returns: A modified copy of the element with conditional visibility.
    func hidden(_ queries: any Query...) -> some HTML {
        AnyHTML(hiddenModifier(queries: queries))
    }
}

public extension StyledHTML {
    /// Hides the view in the view hierarchy.
    func hidden() -> Self {
        self.style(.display, "none")
    }
}

private extension HTML {
    func hiddenModifier(_ isHidden: Bool = false, queries: [any Query] = []) -> any HTML {
        if queries.isEmpty {
            return self.class(isHidden ? "d-none" : nil)
        } else {
            let manager = CSSManager.shared
            let className = manager.registerStyles(queries, styles: [.init(.display, value: "none")])
            return self.class(className)
        }
    }
}
