//
// Hidden.swift
// IgniteSamples
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A modifier that controls element visibility
struct HiddenModifier: HTMLModifier {
    /// Whether the element should be hidden
    private let isHidden: Bool
    
//    /// The media query that triggers hiding, if using responsive hiding
//    private let mediaQuery: (any QueryType)?
    
    /// Creates a new hidden modifier with a boolean flag
    /// - Parameter isHidden: Whether to hide the element
    init(isHidden: Bool = true) {
        self.isHidden = isHidden
//        self.mediaQuery = nil
    }
    
//    /// Creates a new hidden modifier with a media query condition
//    /// - Parameter mediaQuery: The media query that triggers hiding
//    init(mediaQuery: any QueryType) {
//        self.isHidden = true
//        self.mediaQuery = mediaQuery
//    }
    
    /// Applies visibility styling to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with visibility applied
    func body(content: some HTML) -> any HTML {
//        if let mediaQuery {
//            let condition = "(\(mediaQuery.query): \(mediaQuery.rawValue))"
//            let style = ResolvedStyle(
//                property: "display",
//                value: "none !important",
//                mediaQueries: [MediaQuery(conditions: [condition])]
//            )
//            let className = style.register()
//            return content.class(className)
//        }
        
        return content.class(isHidden ? "d-none" : nil)
    }
}

public extension HTML {
    /// Optionally hides the view in the view hierarchy.
    /// - Parameter isHidden: Whether to hide this element or not.
    /// - Returns: A modified copy of the element with visibility applied
    func hidden(_ isHidden: Bool = true) -> some HTML {
        modifier(HiddenModifier(isHidden: isHidden))
    }
    
//    /// Hides the element when the specified media query condition is met.
//    /// - Parameter mediaQuery: The media query condition that triggers hiding the element
//    /// - Returns: A modified copy of the element with conditional hiding applied
//    func hidden(_ mediaQuery: any QueryType) -> some HTML {
//        modifier(HiddenModifier(mediaQuery: mediaQuery))
//    }
}
