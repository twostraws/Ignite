//
// LineHeight.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that controls line height spacing
struct LineHeightModifier: HTMLModifier {
    /// The custom line height value to apply
    private let customHeight: Double?
    
    /// The predefined Bootstrap line height to apply
    private let presetHeight: LineHeight?
    
    /// Creates a new line height modifier with a custom value
    init(height: Double) {
        self.customHeight = height
        self.presetHeight = nil
    }
    
    /// Creates a new line height modifier with a preset value
    init(height: LineHeight) {
        self.customHeight = nil
        self.presetHeight = height
    }
    
    func body(content: some HTML) -> any HTML {
        if content.body.isComposite {
            if let customHeight {
                content.containerStyle(.init(name: "line-height", value: String(customHeight)))
            } else if let presetHeight {
                content.containerClass("lh-\(presetHeight.rawValue)")
            }
        } else {
            if let customHeight {
                content.style("line-height: \(customHeight)")
            } else if let presetHeight {
                content.class("lh-\(presetHeight.rawValue)")
            }
        }
        content
    }
}

public extension HTML {
    /// Sets the line height of the element using a custom value.
    /// - Parameter height: The line height multiplier to use
    /// - Returns: The modified HTML element
    func lineHeight(_ height: Double) -> some HTML {
        modifier(LineHeightModifier(height: height))
    }
    
    /// Sets the line height of the element using a predefined Bootstrap value.
    /// - Parameter height: The predefined line height to use
    /// - Returns: The modified HTML element
    func lineHeight(_ height: LineHeight) -> some HTML {
        modifier(LineHeightModifier(height: height))
    }
}

public extension BlockHTML {
    /// Sets the line height of the element using a custom value.
    /// - Parameter height: The line height multiplier to use
    /// - Returns: The modified HTML element
    func lineHeight(_ height: Double) -> some BlockHTML {
        modifier(LineHeightModifier(height: height))
    }
    
    /// Sets the line height of the element using a predefined Bootstrap value.
    /// - Parameter height: The predefined line height to use
    /// - Returns: The modified HTML element
    func lineHeight(_ height: LineHeight) -> some BlockHTML {
        modifier(LineHeightModifier(height: height))
    }
}

/// Predefined line height values that match Bootstrap's spacing system.
public enum LineHeight: String, CaseIterable {
    /// Single line height (1.0)
    case tight = "1"
    
    /// Compact line height (1.25)
    case small = "sm"
    
    /// Default line height (1.5)
    case base = "base"
    
    /// Relaxed line height (2.0)
    case large = "lg"
    
    /// The actual multiplier value for this line height
    var value: Double {
        switch self {
            case .tight: return 1.0
            case .small: return 1.25
            case .base: return 1.5
            case .large: return 2.0
        }
    }
}
