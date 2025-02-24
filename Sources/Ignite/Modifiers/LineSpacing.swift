//
// LineHeight.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that controls line height spacing
struct LineSpacingModifier: HTMLModifier {
    /// The custom line height value to apply
    private let customHeight: Double?

    /// The predefined Bootstrap line height to apply
    private let presetHeight: LineSpacing?

    /// Creates a new line height modifier with a custom value
    init(height: Double) {
        self.customHeight = height
        self.presetHeight = nil
    }

    /// Creates a new line height modifier with a preset value
    init(height: LineSpacing) {
        self.customHeight = nil
        self.presetHeight = height
    }

    func body(content: some HTML) -> any HTML {
        if content.isText {
            applyLineHeightToText(content: content)
        } else {
            applyLineHeightToNonText(content: content)
        }
    }

    private func applyLineHeightToText(content: some HTML) -> any HTML {
        if let customHeight {
            content.style(.init(.lineHeight, value: customHeight.formatted(.nonLocalizedDecimal)))
        } else if let presetHeight {
            content.class("lh-\(presetHeight.rawValue)")
        } else {
            content
        }
    }

    private func applyLineHeightToNonText(content: some HTML) -> any HTML {
        if let customHeight {
            Section(content.class("line-height-inherit"))
                .style(.lineHeight, customHeight.formatted(.nonLocalizedDecimal))
        } else if let presetHeight {
            Section(content.class("line-height-inherit"))
                .class("lh-\(presetHeight.rawValue)")
        } else {
            content
        }
    }
}

public extension HTML {
    /// Sets the line height of the element using a custom value.
    /// - Parameter spacing: The line height multiplier to use.
    /// - Returns: The modified HTML element.
    func lineSpacing(_ spacing: Double) -> some HTML {
        modifier(LineSpacingModifier(height: spacing))
    }

    /// Sets the line height of the element using a predefined Bootstrap value.
    /// - Parameter spacing: The predefined line height to use.
    /// - Returns: The modified HTML element.
    func lineSpacing(_ spacing: LineSpacing) -> some HTML {
        modifier(LineSpacingModifier(height: spacing))
    }
}

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
