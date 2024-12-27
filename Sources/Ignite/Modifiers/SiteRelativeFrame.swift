//
// SiteRelativeFrame.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies Bootstrap's container class for site-wide content width.
struct SiteRelativeFrame: HTMLModifier {
    /// Applies Bootstrap's container class to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with container class applied for consistent site margins
    func body(content: some HTML) -> any HTML {
        content.class("container")
    }
}

public extension HTML {
    /// Makes the element respect the site's content width using Bootstrap's container class.
    /// - Returns: A copy of the current element with site-relative width applied.
    func siteRelativeFrame() -> some HTML {
        modifier(SiteRelativeFrame())
    }
}

public extension BlockHTML {
    /// Makes the element respect the site's content width using Bootstrap's container class.
    /// - Returns: A copy of the current element with site-relative width applied.
    func siteRelativeFrame() -> some BlockHTML {
        modifier(SiteRelativeFrame())
    }
}
