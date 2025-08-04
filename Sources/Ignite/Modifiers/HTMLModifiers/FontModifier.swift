//
// FontModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies font styling to HTML content.
struct FontModifier: HTMLModifier {
    var font: Font

    /// Creates modified HTML content with the specified font styling.
    func body(content: Content) -> some HTML {
        Self.register(font: font)
        return FontModifiedHTML(content, font: font)
    }

    /// Registers a font family with the CSS manager if it has a name.
    /// - Parameter font: The font to register.
    static func register(font: Font) {
        if let name = font.name, !name.isEmpty {
            CSSManager.shared.registerFontFamily(font)
        }
    }

    /// Generates CSS attributes for the specified font configuration.
    /// - Parameters:
    ///   - font: The font to generate attributes for.
    ///   - includeStyle: Whether to include style classes in the output.
    /// - Returns: Core attributes containing the font styling.
    static func attributes(for font: Font, includeStyle: Bool) -> CoreAttributes {
        var attributes = CoreAttributes()

        if let weight = font.weight {
            attributes.append(styles: .init(.fontWeight, value: weight.description))
        }

        if let name = font.name, !name.isEmpty {
            attributes.append(styles: .init(.fontFamily, value: "'\(name)'"))
        }

        if let responsiveSize = font.responsiveSize {
            let className = CSSManager.shared.registerFont(responsiveSize)
            attributes.append(classes: className)
        } else if let size = font.size {
            attributes.append(styles: .init(.fontSize, value: size.stringValue))
        }

        if includeStyle, let style = font.style, let sizeClass = style.sizeClass {
            attributes.append(classes: sizeClass)
        }

        return attributes
    }
}

public extension HTML {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> some HTML {
        return FontModifiedHTML(self, font: font)
    }

    /// Adjusts the font of this text using responsive sizing.
    /// - Parameter font: The responsive font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font.Responsive) -> some HTML {
        return modifier(FontModifier(font: font.font))
    }
}
