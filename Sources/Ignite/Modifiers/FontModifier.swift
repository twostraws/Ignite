//
// FontModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies font styling to HTML elements.
struct FontModifier: HTMLModifier {
    /// The font configuration to apply
    var font: Font

    /// Applies the font styling to the provided HTML content.
    /// - Parameter content: The HTML content to modify
    /// - Returns: The modified HTML content with font styling applied
    func body(content: some HTML) -> any HTML {
        let isText = content.body is Text ||
            (content as? ModifiedHTML)?.content is Text

        return if isText {
            applyFontToText(content: content)
        } else {
            applyFontToNonText(content: content)
        }
    }

    /// Applies font styling to text content
    /// - Parameter content: The text HTML content to modify
    /// - Returns: The modified HTML content with font styling applied
    private func applyFontToText(content: some HTML) -> any HTML {
        var modified: any HTML = content.style(.fontWeight, font.weight.rawValue.formatted())

        if let style = font.style {
            modified = modified.fontStyle(style)
        }

        if let name = font.name, name.isEmpty == false {
            modified = modified.style(.fontFamily, name)
        }

        if let responsiveSize = font.responsiveSize {
            let classNames = registerClasses(for: responsiveSize)
            modified = modified.class(classNames)
        } else if let size = font.size {
            modified = modified.style(.fontSize, size.stringValue)
        }

        return modified
    }

    /// Applies font styling to non-text content
    /// - Parameter content: The non-text HTML content to modify
    /// - Returns: The modified HTML content with font styling applied
    private func applyFontToNonText(content: some HTML) -> any HTML {
        var styles = [InlineStyle]()
        var classes = [String]()

        styles.append(.init(.fontWeight, value: String(font.weight.rawValue)))

        if let name = font.name, name.isEmpty == false {
            styles.append(.init(.fontFamily, value: name))
        }

        if let responsiveSize = font.responsiveSize {
            let classNames = registerClasses(for: responsiveSize)
            classes.append(classNames)
        } else if let size = font.size {
            styles.append(.init(.fontSize, value: size.stringValue))
        } else if let style = font.style {
            styles.append(.init(.fontSize, value: style.sizeVariable))
        }

        return Section(content.class("font-inherit"))
            .style(styles)
            .class(classes)
    }

    /// Registers CSS classes for responsive font sizes and returns the generated class name.
    /// - Parameter responsiveSize: The responsive font size.
    /// - Returns: A unique class name that applies the font's responsive size rules.
    private func registerClasses(for responsiveSize: ResponsiveFontSize) -> String {
        let className = "font-" + responsiveSize.breakpointValues.description.truncatedHash

        // Sort sizes by breakpoint to ensure proper cascading
        let allSizes = responsiveSize.breakpointValues.sorted { size1, size2 in
            let bp1 = size1.breakpoint
            let bp2 = size2.breakpoint

            // nil (base size) should come first
            if bp1 == nil { return true }
            if bp2 == nil { return false }
            return bp1! < bp2!
        }

        // Find base size and breakpoint sizes
        let baseSize = allSizes.first { size in
            size.breakpoint == nil
        }

        let breakpointSizes = allSizes.filter { size in
            size.breakpoint != nil
        }

        if let baseSize {
            CSSManager.shared.register(
                properties: [("font-size", baseSize.value.stringValue)],
                className: className)
        }

        for size in breakpointSizes {
            if let breakpoint = size.breakpoint {
                CSSManager.shared.register(
                    [.breakpoint(.init(stringValue: breakpoint)!)],
                    properties: [("font-size", size.value.stringValue)],
                    className: className)
            }
        }

        return className
    }
}

public extension HTML {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> some HTML {
        modifier(FontModifier(font: font))
    }
}

public extension InlineElement {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> some InlineElement {
        modifier(FontModifier(font: font))
    }
}
