//
// HeadingScale.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

//
// HeadingScale.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A collection of responsive font sizes for each heading level
public struct HeadingSizes {
    /// Font sizes for h1 elements (largest) at different breakpoints
    public let h1: ResponsiveValues<LengthUnit>?

    /// Font sizes for h2 elements at different breakpoints
    public let h2: ResponsiveValues<LengthUnit>?

    /// Font sizes for h3 elements at different breakpoints
    public let h3: ResponsiveValues<LengthUnit>?

    /// Font sizes for h4 elements at different breakpoints
    public let h4: ResponsiveValues<LengthUnit>?

    /// Font sizes for h5 elements at different breakpoints
    public let h5: ResponsiveValues<LengthUnit>?

    /// Font sizes for h6 elements (smallest) at different breakpoints
    public let h6: ResponsiveValues<LengthUnit>?

    /// Creates a new heading scale
    /// - Parameters:
    ///   - h1: Sizes for h1 elements at different breakpoints. Pass `nil` to use theme default.
    ///   - h2: Sizes for h2 elements at different breakpoints. Pass `nil` to use theme default.
    ///   - h3: Sizes for h3 elements at different breakpoints. Pass `nil` to use theme default.
    ///   - h4: Sizes for h4 elements at different breakpoints. Pass `nil` to use theme default.
    ///   - h5: Sizes for h5 elements at different breakpoints. Pass `nil` to use theme default.
    ///   - h6: Sizes for h6 elements at different breakpoints. Pass `nil` to use theme default.
    public init(
        h1: ResponsiveValues<LengthUnit>? = nil,
        h2: ResponsiveValues<LengthUnit>? = nil,
        h3: ResponsiveValues<LengthUnit>? = nil,
        h4: ResponsiveValues<LengthUnit>? = nil,
        h5: ResponsiveValues<LengthUnit>? = nil,
        h6: ResponsiveValues<LengthUnit>? = nil
    ) {
        self.h1 = h1
        self.h2 = h2
        self.h3 = h3
        self.h4 = h4
        self.h5 = h5
        self.h6 = h6
    }
}
