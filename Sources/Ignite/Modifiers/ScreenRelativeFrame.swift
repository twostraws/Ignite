//
// ScreenFrame.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A modifier that positions elements relative to the screen dimensions.
struct ScreenRelativeFrameModifier: HTMLModifier {
    /// The axes to apply screen-relative positioning to
    var axes: Axis
    
    /// Applies screen-relative positioning to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with screen-relative positioning applied
    func body(content: some HTML) -> any HTML {
        let modified = content

        if axes.contains(.horizontal) {
            modified.style("margin-inline: calc(50% - 50vw)")
        }

        if axes.contains(.vertical) {
            modified.style("margin-block: calc(50% - 50vh)")
        }
        
        return modified
    }
}

public extension BlockHTML {
    /// Makes the element's frame relative to the screen edges rather than its parent container.
    /// - Parameters:
    ///   - axes: Which axes should be relative to the screen.
    /// - Returns: A copy of the current element with screen-relative framing applied.
    func screenRelativeFrame(_ axes: Axis = .all) -> some BlockHTML {
        modifier(ScreenRelativeFrameModifier(axes: axes))
    }
}
