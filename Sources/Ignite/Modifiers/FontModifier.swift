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

            if let name = font.name, name.isEmpty == false {
                modified = modified.style("font-family: \(name)")
            }

            // Only apply the style class if no custom size is specified
            if let style = font.style {
                if font.size == nil {
                    modified = modified.fontStyle(style)
                } else {
                    // If we have a custom size, don't apply the Bootstrap class
                    modified = modified.style("font-size: \(font.size!)px")
                }
            }

            return modified
        } else {
            var containerAttributes = ContainerAttributes(styles: [
                .init(name: "font-weight", value: String(font.weight.rawValue))
            ])

            if let name = font.name, name.isEmpty == false {
                containerAttributes.styles.append(AttributeValue(name: "font-family", value: name))
            }

            // Only apply the style class if no custom size is specified
            if let style = font.style {
                if font.size == nil {
                    containerAttributes.classes.append(style.fontSizeClass)
                } else {
                    // If we have a custom size, don't apply the Bootstrap class
                    containerAttributes.styles.append(AttributeValue(name: "font-size", value: "\(font.size!)px"))
                }
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
