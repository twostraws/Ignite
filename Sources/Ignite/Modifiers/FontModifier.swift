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
            CSSManager.default.register(
                [],
                properties: [("font-size", baseSize.value.stringValue)],
                className: className
            )
        }

        for size in breakpointSizes {
            if let breakpoint = size.breakpoint {
                CSSManager.default.register(
                    [.breakpoint(.init(rawValue: breakpoint)!)],
                    properties: [("font-size", size.value.stringValue)],
                    className: className
                )
            }
        }

        return className
    }

    /// Applies the font styling to the provided HTML content.
    /// - Parameter content: The HTML content to modify
    /// - Returns: The modified HTML content with font styling applied
    func body(content: some HTML) -> any HTML {
        let isText = content.body is Text ||
            (content as? ModifiedHTML)?.content is Text

        if isText {
            content.style(.fontWeight, font.weight.rawValue.formatted())

            if let style = font.style {
                content.fontStyle(style)
            }

            if let name = font.name, name.isEmpty == false {
                content.style(.fontFamily, name)
            }

            if let responsiveSize = font.responsiveSize {
                let classNames = registerClasses(for: responsiveSize)
                content.class(classNames)
            } else if let size = font.size {
                content.style(.fontSize, size.stringValue)
            }

            return content
        } else {
            var containerAttributes = ContainerAttributes(styles: [
                .init(.fontWeight, value: String(font.weight.rawValue))
            ])

            if let name = font.name, name.isEmpty == false {
                containerAttributes.styles
                    .append(InlineStyle(.fontFamily, value: name))
            }

            if let responsiveSize = font.responsiveSize {
                let classNames = registerClasses(for: responsiveSize)
                containerAttributes.classes.append(classNames)
            } else if let size = font.size {
                containerAttributes.styles.append(.init(.fontSize, value: size.stringValue))
            } else if let style = font.style {
                containerAttributes.styles.append(.init(.fontSize, value: style.sizeVariable))
            }

            return content
                .containerAttributes(containerAttributes)
                .class("font-inherit")
        }
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
