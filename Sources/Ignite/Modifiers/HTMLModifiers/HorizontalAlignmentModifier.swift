//
// HorizontalAlignmentModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

enum AlignmentType {
    case universal(HorizontalAlignment)
    case responsive(HorizontalAlignment.ResponsiveAlignment)
}

/// A modifier that applies horizontal alignment classes to HTML elements.
private struct HorizontalAlignmentModifier: HTMLModifier {
    /// The alignment configuration to apply.
    var alignment: AlignmentType

    func body(content: Content) -> some HTML {
        var content = content
           switch alignment {
           case .universal(let alignment):
               content.attributes.append(classes: alignment.rawValue)
           case .responsive(let alignment):
               content.attributes.append(classes: alignment.containerAlignmentClasses)
           }
           return content
    }
}

public extension HTML {
    /// Aligns this element using a specific alignment.
    /// - Parameter alignment: How to align this element.
    /// - Returns: A modified copy of the element with alignment applied
    func horizontalAlignment(_ alignment: HorizontalAlignment) -> some HTML {
        modifier(HorizontalAlignmentModifier(alignment: .universal(alignment)))
    }

    /// Aligns this element using multiple responsive alignments.
    /// - Parameter alignment: One or more alignments with optional breakpoints.
    /// - Returns: A modified copy of the element with alignments applied
    func horizontalAlignment(_ alignment: HorizontalAlignment.ResponsiveAlignment) -> some HTML {
       modifier(HorizontalAlignmentModifier(alignment: .responsive(alignment)))
    }
}

public extension StyledHTML {
    /// Aligns this element using a specific alignment.
    /// - Parameter alignment: How to align this element.
    /// - Returns: A modified copy of the element with alignment applied
    func horizontalAlignment(_ alignment: HorizontalAlignment) -> Self {
        style(alignment.itemAlignmentStyle)
    }
}
