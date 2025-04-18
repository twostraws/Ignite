//
// LineHeight.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Predefined line height values that match Bootstrap's spacing system.
public enum LineSpacing: String, CaseIterable, Sendable {
    /// Single line height (1.0)
    case xSmall = "1"

    /// Compact line height (1.25)
    case small = "sm"

    /// Default line height (1.5)
    case standard = "base"

    /// Relaxed line height (2.0)
    case large = "lg"

    /// The actual multiplier value for this line height
    var value: Double {
        switch self {
        case .xSmall: 1.0
        case .small: 1.25
        case .standard: 1.5
        case .large: 2.0
        }
    }
}

private enum LineSpacingType {
    case exact(Double), semantic(LineSpacing)
}

@MainActor
private func lineSpacingModifier(_ spacing: LineSpacingType, content: any Element) -> any Element {
    if content.isText {
        switch spacing {
        case .exact(let spacing):
            return content.style(.init(.lineHeight, value: spacing.formatted(.nonLocalizedDecimal)))
        case .semantic(let spacing):
            return content.class("lh-\(spacing.rawValue)")
        }
    } else {
        switch spacing {
        case .exact(let spacing):
            return Section(content.class("line-height-inherit"))
                .style(.lineHeight, spacing.formatted(.nonLocalizedDecimal))
        case .semantic(let spacing):
            return Section(content.class("line-height-inherit"))
                .class("lh-\(spacing.rawValue)")
        }
    }
}

@MainActor
private func lineSpacingModifier(_ spacing: LineSpacingType, content: any InlineElement) -> any InlineElement {
    switch spacing {
    case .exact(let spacing):
        return content.style(.lineHeight, spacing.formatted(.nonLocalizedDecimal))
    case .semantic(let spacing):
        return content.class("lh-\(spacing.rawValue)")
    }
}

public extension Element {
    /// Sets the line height of the element using a custom value.
    /// - Parameter spacing: The line height multiplier to use.
    /// - Returns: The modified HTML element.
    func lineSpacing(_ spacing: Double) -> some Element {
        AnyHTML(lineSpacingModifier(.exact(spacing), content: self))
    }

    /// Sets the line height of the element using a predefined Bootstrap value.
    /// - Parameter spacing: The predefined line height to use.
    /// - Returns: The modified HTML element.
    func lineSpacing(_ spacing: LineSpacing) -> some Element {
        AnyHTML(lineSpacingModifier(.semantic(spacing), content: self))
    }
}

public extension InlineElement {
    /// Sets the line height of the element using a custom value.
    /// - Parameter spacing: The line height multiplier to use.
    /// - Returns: The modified InlineElement element.
    func lineSpacing(_ spacing: Double) -> some InlineElement {
        AnyInlineElement(lineSpacingModifier(.exact(spacing), content: self))
    }

    /// Sets the line height of the element using a predefined Bootstrap value.
    /// - Parameter spacing: The predefined line height to use.
    /// - Returns: The modified InlineElement element.
    func lineSpacing(_ spacing: LineSpacing) -> some InlineElement {
        AnyInlineElement(lineSpacingModifier(.semantic(spacing), content: self))
    }
}

public extension StyledHTML {
    /// Sets the line height of the element using a custom value.
    /// - Parameter height: The line height multiplier to use
    /// - Returns: The modified HTML element
    func lineSpacing(_ height: Double) -> Self {
        self.style(.lineHeight, String(height))
    }
}
