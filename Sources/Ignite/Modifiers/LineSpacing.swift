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

public extension HTML {
    /// Sets the line height of the element using a custom value.
    /// - Parameter spacing: The line height multiplier to use.
    /// - Returns: The modified HTML element.
    func lineSpacing(_ spacing: Double) -> some HTML {
        AnyHTML(lineSpacingModifier(.exact(spacing)))
    }

    /// Sets the line height of the element using a predefined Bootstrap value.
    /// - Parameter spacing: The predefined line height to use.
    /// - Returns: The modified HTML element.
    func lineSpacing(_ spacing: LineSpacing) -> some HTML {
        AnyHTML(lineSpacingModifier(.semantic(spacing)))
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

private enum LineSpacingType {
    case exact(Double), semantic(LineSpacing)
}

private extension HTML {
    func lineSpacingModifier(_ spacing: LineSpacingType) -> any HTML {
        if self.isTextualElement {
            self.applyToText(spacing)
        } else {
            self.applyToNonText(spacing)
        }
    }

    func applyToText(_ spacing: LineSpacingType) -> any HTML {
        switch spacing {
        case .exact(let spacing):
            self.style(.init(.lineHeight, value: spacing.formatted(.nonLocalizedDecimal)))
        case .semantic(let spacing):
            self.class("lh-\(spacing.rawValue)")
        }
    }

    func applyToNonText(_ spacing: LineSpacingType) -> any HTML {
        switch spacing {
        case .exact(let spacing):
            Section(self.class("line-height-inherit"))
                .style(.lineHeight, spacing.formatted(.nonLocalizedDecimal))
        case .semantic(let spacing):
            Section(self.class("line-height-inherit"))
                .class("lh-\(spacing.rawValue)")
        }
    }
}
