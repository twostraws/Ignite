//
// Material.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A style that applies a translucent material effect to a view's background.
///
/// Material effects combine translucency, blur, and color to create the appearance
/// of frosted glass. The effect automatically adapts to light and dark color schemes.
public struct Material: Style {
    /// The CSS class name to apply
    public let className: String

    /// The type of material effect to apply
    private let type: MaterialType

    /// The available material types, matching SwiftUI's Material options
    public enum MaterialType: String, Sendable {
        case ultraThin = "ultra-thin"
        case thin = "thin"
        case regular = "regular"
        case thick = "thick"
        case ultraThick = "ultra-thick"
    }

    /// Private initializer to enforce the use of static properties
    /// - Parameters:
    ///   - type: The type of material effect to apply
    ///   - colorScheme: An optional color scheme to override the default behavior
    private init(_ type: MaterialType, colorScheme: ColorScheme? = nil) {
        self.type = type
        var name = "material-\(type.rawValue)"
        if let colorScheme {
            name += "-\(colorScheme.rawValue)"
        }
        self.className = name
    }

    /// Resolves the style into its concrete implementation
    /// - Returns: A style that applies the appropriate material class based on the color scheme
    public var body: some Style {
        ResolvedStyle(className: className)
    }

    /// Method to override the color scheme
    /// - Parameter scheme: The color scheme to use
    /// - Returns: A new Material instance with the specified color scheme
    public func colorScheme(_ scheme: ColorScheme) -> Material {
        Material(type, colorScheme: scheme)
    }

    /// An ultra-thin material effect
    @MainActor public static let ultraThin = Material(.ultraThin)

    /// A thin material effect
    @MainActor public static let thin = Material(.thin)

    /// A regular material effect
    @MainActor public static let regular = Material(.regular)

    /// A thick material effect
    @MainActor public static let thick = Material(.thick)

    /// An ultra-thick material effect
    @MainActor public static let ultraThick = Material(.ultraThick)
}

/// Material effects for backgrounds
public extension Style where Self == Material {
    /// An ultra-thin material effect that adapts to light/dark mode
    @MainActor static var ultraThinMaterial: Self { .ultraThin }

    /// A thin material effect that adapts to light/dark mode
    @MainActor static var thinMaterial: Self { .thin }

    /// A regular material effect that adapts to light/dark mode
    @MainActor static var regularMaterial: Self { .regular }

    /// A thick material effect that adapts to light/dark mode
    @MainActor static var thickMaterial: Self { .thick }

    /// An ultra-thick material effect that adapts to light/dark mode
    @MainActor static var ultraThickMaterial: Self { .ultraThick }
}
