//
// FontModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private func fontModifier(_ font: Font, content: any HTML) -> any HTML {
    if let content = content.as(Text.self) {
        var styles = [InlineStyle]()
        styles.append(.init(.fontWeight, value: font.weight.rawValue.formatted()))

        if let name = font.name, !name.isEmpty {
            styles.append(.init(.fontFamily, value: "'\(name)'"))
        }

        if let size = font.size {
            styles.append(.init(.fontSize, value: size.stringValue))
        }

        var modified: any HTML = content.style(styles)

        if let style = font.style, let sizeVariable = style.sizeVariable {
            styles.append(.init(.fontSize, value: sizeVariable))
        }

        if let responsiveSize = font.responsiveSize {
            let classNames = CSSManager.className(forFont: responsiveSize)
            modified = modified.class(classNames)
            modified.attributes.append(publishingRegistration: .responsiveFont(responsiveSize))
        }

        return modified
    } else {
        var styles = [InlineStyle]()
        var classes = [String]()

        styles.append(.init(.fontWeight, value: String(font.weight.rawValue)))

        if let name = font.name, !name.isEmpty {
            styles.append(.init(.fontFamily, value: "'\(name)'"))
        }

        if let size = font.size {
            styles.append(.init(.fontSize, value: size.stringValue))
        } else if let style = font.style, let sizeVariable = style.sizeVariable {
            styles.append(.init(.fontSize, value: sizeVariable))
        }

        if let responsiveSize = font.responsiveSize {
            classes.append(CSSManager.className(forFont: responsiveSize))
        }

        var modified: any HTML = Section(content.class("font-inherit"))
            .style(styles)
            .class(classes)

        if let responsiveSize = font.responsiveSize {
            modified.attributes.append(publishingRegistration: .responsiveFont(responsiveSize))
        }

        return modified
    }
}

private func fontModifier(_ font: Font, content: any InlineElement) -> any InlineElement {
    var styles = [InlineStyle]()
    styles.append(.init(.fontWeight, value: font.weight.rawValue.formatted()))

    if let name = font.name, !name.isEmpty {
        styles.append(.init(.fontFamily, value: "'\(name)'"))
    }

    if let size = font.size {
        styles.append(.init(.fontSize, value: size.stringValue))
    }

    var modified = content.style(styles)

    if let style = font.style, let sizeVariable = style.sizeVariable {
        styles.append(.init(.fontSize, value: sizeVariable))
    }

    if let responsiveSize = font.responsiveSize {
        let classNames = CSSManager.className(forFont: responsiveSize)
        modified = modified.class(classNames)
        modified.attributes.append(publishingRegistration: .responsiveFont(responsiveSize))
    }

    return modified
}

public extension HTML {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> some HTML {
        var modified = fontModifier(font, content: self)
        if let name = font.name, !name.isEmpty {
            modified.attributes.append(publishingRegistration: .fontFamily(font))
        }
        return AnyHTML(modified)
    }

    /// Adjusts the font of this text using responsive sizing.
    /// - Parameter font: The responsive font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font.Responsive) -> some HTML {
        let baseFont = font.font
        var modified = fontModifier(baseFont, content: self)
        if let name = baseFont.name, !name.isEmpty {
            modified.attributes.append(publishingRegistration: .fontFamily(baseFont))
        }
        return AnyHTML(modified)
    }
}

public extension InlineElement {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> some InlineElement {
        var modified = fontModifier(font, content: self)
        if let name = font.name, !name.isEmpty {
            modified.attributes.append(publishingRegistration: .fontFamily(font))
        }
        return AnyInlineElement(modified)
    }

    /// Adjusts the font of this text using responsive sizing.
    /// - Parameter font: The responsive font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font.Responsive) -> some InlineElement {
        let baseFont = font.font
        var modified = fontModifier(baseFont, content: self)
        if let name = baseFont.name, !name.isEmpty {
            modified.attributes.append(publishingRegistration: .fontFamily(baseFont))
        }
        return AnyInlineElement(modified)
    }
}

public extension StyledHTML {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> Self {
        var styles = [InlineStyle]()
        styles.append(.init(.fontWeight, value: font.weight.description))

        if let style = font.style {
            styles.append(.init(.fontStyle, value: style.rawValue))
        }

        if let name = font.name, !name.isEmpty {
            styles.append(.init(.fontFamily, value: "'\(name)'"))
        }

        if let size = font.size {
            styles.append(.init(.fontSize, value: size.stringValue))
        }

        var modified = self.style(styles)

        if let name = font.name, !name.isEmpty {
            modified.attributes.append(publishingRegistration: .fontFamily(font))
        }

        return modified
    }
}
