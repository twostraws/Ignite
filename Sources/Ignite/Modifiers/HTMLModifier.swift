//
// HTMLModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines how HTML content can be modified.
///
/// HTMLModifier provides a standardized way to apply styling, attributes, and other modifications
/// to HTML elements while preserving their structure and type information.
@MainActor
public protocol HTMLModifier {
    /// Applies modifications to the provided HTML content.
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with changes applied
    @HTMLBuilder func body(content: some HTML) -> any HTML
}

public extension HTML {
    /// Applies a modifier to this HTML element.
    /// - Parameter modifier: The modifier to apply to this element
    /// - Returns: A modified copy of the element with changes applied
    func modifier<M: HTMLModifier>(_ modifier: M) -> some HTML {
        ModifiedHTML(self, modifier: modifier)
    }
}

public extension HTML where Self: InlineHTML {
    /// Applies a modifier to this inline HTML element while preserving its inline nature.
    /// - Parameter modifier: The modifier to apply to this element
    /// - Returns: A modified copy of the element with changes applied, maintaining inline status
    func modifier<M: HTMLModifier>(_ modifier: M) -> some InlineHTML {
        ModifiedHTML(self, modifier: modifier)
    }
}

public extension HTML where Self: BlockHTML {
    /// Applies a modifier to this block HTML element while preserving its block nature.
    /// - Parameter modifier: The modifier to apply to this element
    /// - Returns: A modified copy of the element with changes applied, maintaining block status
    func modifier<M: HTMLModifier>(_ modifier: M) -> some BlockHTML {
        ModifiedHTML(self, modifier: modifier)
    }
}

public extension HTML where Self: RootHTML {
    /// Applies a modifier to this HTML root element while preserving its block nature.
    /// - Parameter modifier: The modifier to apply to this element
    /// - Returns: A modified copy of the element with changes applied, maintaining block status
    func modifier<M: HTMLModifier>(_ modifier: M) -> some RootHTML {
        ModifiedHTML(self, modifier: modifier)
    }
}
