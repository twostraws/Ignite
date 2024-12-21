//
// UnorderedListStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public enum UnorderedListMarkerStyle: String, Sendable {
    /// Lists are shown with filled circle bullet points.
    case automatic = "disc"

    /// Lists are shown with hollow circle bullet points.
    case circle = "circle"

    /// Lists are shown with filled square bullet points.
    case square = "square"

    /// Lists are shown with a custom symbol
    case custom = "custom"
}
