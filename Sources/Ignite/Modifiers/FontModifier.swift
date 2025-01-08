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
    /// - Returns: A unique class name that applies the font's responsive size rules.
    private func registerResponsiveClasses() -> String {
        let className = "font-" + font.responsiveSizes.description.truncatedHash

        // Sort sizes by breakpoint to ensure proper cascading
        let sortedSizes = font.responsiveSizes.sorted { size1, size2 in
            let (bp1, _) = size1.resolved
            let (bp2, _) = size2.resolved

            // nil (base size) should come first
            if bp1 == nil { return true }
            if bp2 == nil { return false }
            return bp1! < bp2!
        }

        // Find base size and breakpoint sizes
        let baseSize = sortedSizes.first { size in
            let (breakpoint, _) = size.resolved
            return breakpoint == nil
        }

        let breakpointSizes = sortedSizes.filter { size in
            let (breakpoint, _) = size.resolved
            return breakpoint != nil
        }

        if let (_, value) = baseSize?.resolved {
            CSSManager.default.register(
                [],
                properties: [("font-size", value.stringValue)],
                className: className
            )
        }

        for size in breakpointSizes {
            let (breakpoint, value) = size.resolved
            if let breakpoint = breakpoint {
                CSSManager.default.register(
                    [.breakpoint(.init(rawValue: breakpoint)!)],
                    properties: [("font-size", value.stringValue)],
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
            var modified = content.style("font-weight: \(font.weight.rawValue)")

            if let style = font.style {
                modified.fontStyle(style)
            }

            if let name = font.name, name.isEmpty == false {
                modified.style("font-family: \(name)")
            }

            if !font.responsiveSizes.isEmpty {
                let classNames = registerResponsiveClasses()
                modified.class(classNames)
            } else if let size = font.size {
                modified.style("font-size: \(size.stringValue)")
            } else if let style = font.style {
                modified.style("font-size: \(style.sizeVariable)")
            }

            return modified
        } else {
            var containerAttributes = ContainerAttributes(styles: [
                .init(name: "font-weight", value: String(font.weight.rawValue))
            ])

            if let name = font.name, name.isEmpty == false {
                containerAttributes.styles.append(AttributeValue(name: "font-family", value: name))
            }

            if !font.responsiveSizes.isEmpty {
                let classNames = registerResponsiveClasses()
                containerAttributes.classes.append(classNames)
            } else if let size = font.size {
                containerAttributes.styles.append(AttributeValue(name: "font-size", value: size.stringValue))
            } else if let style = font.style {
                containerAttributes.styles.append(AttributeValue(name: "font-size", value: style.sizeVariable))
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

public extension InlineHTML {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> some InlineHTML {
        modifier(FontModifier(font: font))
    }
}
