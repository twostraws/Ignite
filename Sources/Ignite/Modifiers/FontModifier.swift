//
// FontModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> some HTML {
        if font.name != nil {
            // Custom font that requires CSS generation
            CSSManager.shared.registerFontFamily(font)
        }
        return AnyHTML(fontModifier(font))
    }

    /// Adjusts the font of this text using responsive sizing.
    /// - Parameter font: The responsive font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font.Responsive) -> some HTML {
        let baseFont = font.font
        if baseFont.name != nil {
            // Custom font that requires CSS generation
            CSSManager.shared.registerFontFamily(baseFont)
        }
        return AnyHTML(fontModifier(baseFont))
    }
}

public extension InlineElement {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> some InlineElement {
        if font.name != nil {
            // Custom font that requires CSS generation
            CSSManager.shared.registerFontFamily(font)
        }
        return AnyHTML(fontModifier(font))
    }

    /// Adjusts the font of this text using responsive sizing.
    /// - Parameter font: The responsive font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font.Responsive) -> some InlineElement {
        let baseFont = font.font
        if baseFont.name != nil {
            // Custom font that requires CSS generation
            CSSManager.shared.registerFontFamily(baseFont)
        }
        return AnyHTML(fontModifier(baseFont))
    }
}

public extension StyledHTML {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> Self {
        if font.name != nil {
            // Custom font that requires CSS generation
            CSSManager.shared.registerFontFamily(font)
        }

        var styles = [InlineStyle]()

        styles.append(.init(.fontWeight, value: font.weight.description))

        if let style = font.style {
            styles.append(.init(.fontStyle, value: style.rawValue))
        }

        if let name = font.name, name.isEmpty == false {
            styles.append(.init(.fontFamily, value: name))
        }

        if let size = font.size {
            styles.append(.init(.fontSize, value: size.stringValue))
        }

        return self.style(styles)
    }
}

private extension HTML {
    /// Applies the font styling to the provided HTML content.
    /// - Parameter content: The HTML content to modify
    /// - Returns: The modified HTML content with font styling applied
    func fontModifier(_ font: Font) -> any HTML {
        if self.isTextualElement {
            self.applyToText(font)
        } else {
            self.applyToNonText(font)
        }
    }

    /// Applies font styling to text content
    /// - Parameter content: The text HTML content to modify
    /// - Returns: The modified HTML content with font styling applied
    func applyToText(_ font: Font) -> any HTML {
        var modified: any HTML = self.style(.fontWeight, font.weight.rawValue.formatted())

        if let style = font.style {
            modified = modified.font(style)
        }

        if let name = font.name, name.isEmpty == false {
            modified = modified.style(.fontFamily, name)
        }

        if let responsiveSize = font.responsiveSize {
            let classNames = CSSManager.shared.registerFont(responsiveSize)
            modified = modified.class(classNames)
        } else if let size = font.size {
            modified = modified.style(.fontSize, size.stringValue)
        }

        return modified
    }

    /// Applies font styling to non-text content
    /// - Parameter content: The non-text HTML content to modify
    /// - Returns: The modified HTML content with font styling applied
    func applyToNonText(_ font: Font) -> any HTML {
        var styles = [InlineStyle]()
        var classes = [String]()

        styles.append(.init(.fontWeight, value: String(font.weight.rawValue)))

        if let name = font.name, name.isEmpty == false {
            styles.append(.init(.fontFamily, value: name))
        }

        if let responsiveSize = font.responsiveSize {
            let classNames = CSSManager.shared.registerFont(responsiveSize)
            classes.append(classNames)
        } else if let size = font.size {
            styles.append(.init(.fontSize, value: size.stringValue))
        } else if let style = font.style {
            styles.append(.init(.fontSize, value: style.sizeVariable))
        }

        return Section(self.class("font-inherit"))
            .style(styles)
            .class(classes)
    }
}
