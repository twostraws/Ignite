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
        if content is Text {
            var modified = content

            modified = modified.style("font-weight: \(font.weight.rawValue)")

            if let name = font.name {
                modified = modified.style("font-family: \(name)")
            }

            if let size = font.size {
                modified = modified.style("font-size: \(size)px")
            }

            if let style = font.style {
                modified = modified.fontStyle(style)
            }

            return modified
        } else {
            var containerAttributes = ContainerAttributes(styles: [
                .init(name: "font-weight", value: String(font.weight.rawValue))
            ])

            if let name = font.name {
                containerAttributes.styles.append(AttributeValue(name: "font-family", value: name))
            }

            if let size = font.size {
                containerAttributes.styles.append(AttributeValue(name: "font-size", value: "\(size)px"))
            }

            if let style = font.style {
                containerAttributes.classes.append(style.fontSizeClass)
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
