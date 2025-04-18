//
// FontModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
private func fontModifier(_ font: Font, content: any HTML) -> any HTML {
    if let content = content.as(Text.self) {
        var styles = [InlineStyle]()
        styles.append(.init(.fontWeight, value: font.weight.rawValue.formatted()))

        if let name = font.name, !name.isEmpty {
            styles.append(.init(.fontFamily, value: name))
        }

        if let size = font.size {
            styles.append(.init(.fontSize, value: size.stringValue))
        }

        var modified: any HTML = content.style(styles)

        if let style = font.style {
            modified = modified.font(style)
        }

        if let responsiveSize = font.responsiveSize {
            let classNames = CSSManager.shared.registerFont(responsiveSize)
            modified = modified.class(classNames)
        }

        return modified
    } else {
        var styles = [InlineStyle]()
        var classes = [String]()

        styles.append(.init(.fontWeight, value: String(font.weight.rawValue)))

        if let name = font.name, !name.isEmpty {
            styles.append(.init(.fontFamily, value: name))
        }

        if let size = font.size {
            styles.append(.init(.fontSize, value: size.stringValue))
        } else if let style = font.style {
            styles.append(.init(.fontSize, value: style.sizeVariable))
        }

        if let responsiveSize = font.responsiveSize {
            classes.append(CSSManager.shared.registerFont(responsiveSize))
        }

        return Section(content.class("font-inherit"))
            .style(styles)
            .class(classes)
    }
}

@MainActor
private func fontModifier(_ font: Font, content: any InlineElement) -> any InlineElement {
    var styles = [InlineStyle]()
    styles.append(.init(.fontWeight, value: font.weight.rawValue.formatted()))

    if let name = font.name, !name.isEmpty {
        styles.append(.init(.fontFamily, value: name))
    }

    if let size = font.size {
        styles.append(.init(.fontSize, value: size.stringValue))
    }

    var modified = content.style(styles)

    if let style = font.style {
        modified = modified.font(style)
    }

    if let responsiveSize = font.responsiveSize {
        let classNames = CSSManager.shared.registerFont(responsiveSize)
        modified = modified.class(classNames)
    }

    return modified
}

public extension HTML {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> some HTML {
        if font.name != nil {
            CSSManager.shared.registerFontFamily(font)
        }
        return AnyHTML(fontModifier(font, content: self))
    }

    /// Adjusts the font of this text using responsive sizing.
    /// - Parameter font: The responsive font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font.Responsive) -> some HTML {
        let baseFont = font.font
        if baseFont.name != nil {
            CSSManager.shared.registerFontFamily(baseFont)
        }
        return AnyHTML(fontModifier(baseFont, content: self))
    }
}

public extension InlineElement {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> some InlineElement {
        if font.name != nil {
            CSSManager.shared.registerFontFamily(font)
        }
        return AnyInlineElement(fontModifier(font, content: self))
    }

    /// Adjusts the font of this text using responsive sizing.
    /// - Parameter font: The responsive font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font.Responsive) -> some InlineElement {
        let baseFont = font.font
        if baseFont.name != nil {
            CSSManager.shared.registerFontFamily(baseFont)
        }
        return AnyInlineElement(fontModifier(baseFont, content: self))
    }
}

public extension StyledHTML {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> Self {
        if font.name != nil {
            CSSManager.shared.registerFontFamily(font)
        }

        var styles = [InlineStyle]()
        styles.append(.init(.fontWeight, value: font.weight.description))

        if let style = font.style {
            styles.append(.init(.fontStyle, value: style.rawValue))
        }

        if let name = font.name, !name.isEmpty {
            styles.append(.init(.fontFamily, value: name))
        }

        if let size = font.size {
            styles.append(.init(.fontSize, value: size.stringValue))
        }

        return self.style(styles)
    }
}
