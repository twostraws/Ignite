//
// Style-Font.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension StyledHTML {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> Self {
        FontModifier.register(font: font)
        return style(fontStyles(font))
    }

    /// Converts font properties to CSS inline styles.
    /// - Parameter font: The font configuration to convert.
    /// - Returns: An array of inline styles representing the font properties.
    private func fontStyles(_ font: Font) -> [InlineStyle] {
        var styles = [InlineStyle]()

        if let weight = font.weight {
            styles.append(.init(.fontWeight, value: weight.description))
        }

        if let style = font.style {
            styles.append(.init(.fontStyle, value: style.rawValue))
        }

        if let name = font.name, !name.isEmpty {
            styles.append(.init(.fontFamily, value: "'\(name)'"))
        }

        if let size = font.size {
            styles.append(.init(.fontSize, value: size.stringValue))
        }

        return styles
    }
}
