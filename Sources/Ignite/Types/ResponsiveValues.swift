//
// PublishingContext-ResponsiveValues.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A collection of length values for each responsive breakpoint.
struct ResponsiveValues {
    /// The length value for extra small screens (typically <576px).
    let xSmall: LengthUnit

    /// The length value for small screens (typically ≥576px).
    let small: LengthUnit

    /// The length value for medium screens (typically ≥768px).
    let medium: LengthUnit

    /// The length value for large screens (typically ≥992px).
    let large: LengthUnit

    /// The length value for extra large screens (typically ≥1200px).
    let xLarge: LengthUnit

    /// The length value for extra extra large screens (typically ≥1400px).
    let xxLarge: LengthUnit
}
