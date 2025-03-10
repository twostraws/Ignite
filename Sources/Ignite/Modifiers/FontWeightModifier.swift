//
// FontWeight.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Adjusts the font weight (boldness) of this font.
    /// - Parameter weight: The new font weight.
    /// - Returns: A new `Text` instance with the updated weight.
    func fontWeight(_ weight: Font.Weight) -> some HTML {
        self.style(.fontWeight, weight.rawValue.formatted())
    }
}

public extension InlineElement {
    /// Adjusts the font weight (boldness) of this font.
    /// - Parameter weight: The new font weight.
    /// - Returns: A new `Text` instance with the updated weight.
    func fontWeight(_ weight: Font.Weight) -> some InlineElement {
        self.style(.fontWeight, weight.rawValue.formatted())
    }
}

public extension StyledHTML {
    /// Adjusts the font weight (boldness) of this font.
    /// - Parameter weight: The new font weight.
    /// - Returns: A new instance with the updated weight.
    func fontWeight(_ weight: Font.Weight) -> Self {
        self.style(.fontWeight, weight.description)
    }
}
