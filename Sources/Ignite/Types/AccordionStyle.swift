//
// AccordionStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The visual style of the accordion.
public enum AccordionStyle: Sendable {
    /// A style with outer borders and rounded corners.
    case bordered

    /// Removes outer borders and rounded corners.
    case plain

    /// The default styling based on context.
    public static var automatic: Self { .bordered }
}
