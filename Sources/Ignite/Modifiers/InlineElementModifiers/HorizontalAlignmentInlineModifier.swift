//
// HorizontalAlignmentInlineModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies horizontal alignment to inline elements.
struct HorizontalAlignmentInlineModifier: InlineElementModifier {
    /// The alignment configuration to apply.
    var alignment: AlignmentType

    /// Applies the horizontal alignment to the content.
    /// - Parameter content: The content to modify.
    /// - Returns: The modified content with alignment applied.
    func body(content: Content) -> some InlineElement {
        var modified = content
        switch alignment {
        case .universal(let alignment):
            modified.attributes.append(classes: alignment.rawValue)
            modified.attributes.append(styles: .init(.display, value: "block"))
        case .responsive(let alignment):
            modified.attributes.append(classes: alignment.containerAlignmentClasses)
            modified.attributes.append(styles: .init(.display, value: "block"))
        }
        return modified
    }
}

public extension InlineElement {
    /// Aligns this element using a specific alignment.
    /// - Parameter alignment: How to align this element.
    /// - Returns: A modified copy of the element with alignment applied
    func horizontalAlignment(_ alignment: HorizontalAlignment) -> some InlineElement {
        modifier(HorizontalAlignmentInlineModifier(alignment: .universal(alignment)))
    }

    /// Aligns this element using multiple responsive alignments.
    /// - Parameter alignment: One or more alignments with optional breakpoints.
    /// - Returns: A modified copy of the element with alignments applied
    func horizontalAlignment(_ alignment: HorizontalAlignment.ResponsiveAlignment) -> some InlineElement {
        modifier(HorizontalAlignmentInlineModifier(alignment: .responsive(alignment)))
    }
}
