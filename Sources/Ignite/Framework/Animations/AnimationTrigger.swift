//
// AnimationTrigger.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//
import Foundation

/// Defines the events that can trigger an animation on an HTML element.
public enum AnimationTrigger: String {
    /// Animation triggers when the element is clicked/tapped
    /// - Note: Adds cursor: pointer and click event listener
    case click

    /// Animation triggers when the mouse hovers over the element
    /// - Note: Adds cursor: pointer and :hover CSS selector
    case hover

    /// Animation triggers when the element first appears in the viewport
    /// - Note: Uses IntersectionObserver for viewport detection
    case appear
}
