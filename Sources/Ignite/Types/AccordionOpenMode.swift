//
// AccordionOpenMode.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Controls what happens when a section is opened.
public enum AccordionOpenMode: Sendable {
    /// Opening one accordion section automatically closes all others.
    case individual

    /// Users can open multiple sections simultaneously.
    case all
}
