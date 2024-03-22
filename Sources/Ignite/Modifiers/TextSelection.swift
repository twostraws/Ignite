//
// TextSelection.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Controls whether the user can select the text inside this element or not.
public enum TextSelection {
    case `default`, all, none
}

extension BlockElement {
    /// Adjusts whether the user can select the text inside this element. You of course
    /// welcome to use this how you see fit, but please exercise restraint – not only
    /// does disabling selection annoy some people, but it can cause a genuine
    /// accessibility problem if you aren't careful.
    /// - Parameter selection: The new text selection value.
    /// - Returns: A copy of the current element with the updated text selection value.
    public func textSelection(_ selection: TextSelection) -> Self {
        switch selection {
        case .default:
            self.class("user-select-auto")
        case .all:
            self.class("user-select-all")
        case .none:
            self.class("user-select-none")
        }
    }
}
