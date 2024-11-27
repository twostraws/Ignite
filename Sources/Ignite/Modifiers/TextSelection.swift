//
// TextSelection.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Controls whether the user can select the text inside this element or not.
public enum TextSelection: String {
    case automatic = "auto"
    case all
    case none
}

struct TextSelectionModifier: HTMLModifier {
    var selection: TextSelection
    func body(content: some HTML) -> any HTML {
        content.class("user-select-\(selection)")
    }
}

public extension BlockHTML {
    /// Adjusts whether the user can select the text inside this element. You of course
    /// welcome to use this how you see fit, but please exercise restraint – not only
    /// does disabling selection annoy some people, but it can cause a genuine
    /// accessibility problem if you aren't careful.
    /// - Parameter selection: The new text selection value.
    /// - Returns: A copy of the current element with the updated text selection value.
    func textSelection(_ selection: TextSelection) -> some BlockHTML {
        modifier(TextSelectionModifier(selection: selection))
    }
}
