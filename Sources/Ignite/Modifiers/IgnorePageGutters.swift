//
// ScreenFrame.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that positions elements relative to the screen dimensions.
struct IgnorePageGuttersModifier: HTMLModifier {
    /// Whether this HTML should ignore the page gutters.
    var shouldIgnore: Bool = true

    /// Applies screen-relative positioning to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with full-width positioning applied
    func body(content: some HTML) -> any HTML {
        if shouldIgnore {
            content
                .class("row justify-content-center")
                .style(.marginInline, "calc(50% - 50vw)")
        } else {
            content.class("container")
        }
    }
}

public extension HTML {
    /// Determines whether this element should observe the site
    /// width or extend from one edge of the screen to the other.
    /// - Parameters:
    ///   - ignore: Whether this HTML should ignore the page gutters. Defaults to `true`.
    /// - - Returns: A modified element that either obeys or ignores the page gutters.
    func ignorePageGutters(_ ignore: Bool = true) -> some HTML {
        modifier(IgnorePageGuttersModifier(shouldIgnore: ignore))
    }
}

public extension BlockHTML {
    /// Determines whether this element should observe the site
    /// width or extend from one edge of the screen to the other.
    /// - Parameters:
    ///   - ignore: Whether this HTML should ignore the page gutters. Defaults to `true`.
    /// - Returns: - Returns: A modified element that either obeys or ignores the page gutters.
    func ignorePageGutters(_ ignore: Bool = true) -> some BlockHTML {
        modifier(IgnorePageGuttersModifier(shouldIgnore: ignore))
    }
}
