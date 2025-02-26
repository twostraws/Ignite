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
        AnyHTML(fontModifier(font))
    }
}

public extension InlineElement {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> some InlineElement {
        AnyHTML(fontModifier(font))
    }
}

private extension HTML {
    /// Applies the font styling to the provided HTML content.
    /// - Parameter content: The HTML content to modify
    /// - Returns: The modified HTML content with font styling applied
    func fontModifier(_ font: Font) -> any HTML {
        if self.isText {
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
    func applyToNonText(_ font: Font) -> any HTML {
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

        return Section(self.class("font-inherit"))
            .style(styles)
            .class(classes)
    }

    /// Registers CSS classes for responsive font sizes and returns the generated class name.
    /// - Parameter responsiveSize: The responsive font size.
    /// - Returns: A unique class name that applies the font's responsive size rules.
    func registerClasses(for responsiveSize: ResponsiveFontSize) -> String {
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
                properties: [.init(.fontSize, value: baseSize.value.stringValue)],
                className: className)
        }

        for size in breakpointSizes {
            if let breakpoint = size.breakpoint {
                CSSManager.shared.register(
                    [.breakpoint(.init(stringValue: breakpoint)!)],
                    properties: [.init(.fontSize, value: size.value.stringValue)],
                    className: className)
            }
        }

        return className
    }
}
