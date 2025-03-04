//
// Material.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that represents different material effects that can be applied to views.
/// Material effects combine translucency, blur, and color to create the appearance
/// of frosted glass. The effect automatically adapts to light and dark color schemes.
public struct Material: Sendable {
    /// The type of material effect
    private let type: MaterialType
    /// Optional color scheme override
    private let colorScheme: ColorScheme?

    private enum MaterialType: String {
        case ultraThin = "ultra-thin"
        case thin = "thin"
        case regular = "regular"
        case thick = "thick"
        case ultraThick = "ultra-thick"
    }

    /// Creates a new material with the specified type
    private init(type: MaterialType, colorScheme: ColorScheme? = nil) {
        self.type = type
        self.colorScheme = colorScheme
    }

    /// Method to override the color scheme
    /// - Parameter scheme: The color scheme to use
    /// - Returns: A new Material instance with the specified color scheme
    public func colorScheme(_ scheme: ColorScheme) -> Material {
        Material(type: self.type, colorScheme: scheme)
    }

    /// Gets the CSS class name for this material
    var className: String {
        let baseClass = "material-\(type.rawValue)"
        if let colorScheme {
            return baseClass + "-" + colorScheme.rawValue
        }
        return baseClass
    }

    /// An ultra-thin material effect
    @MainActor public static let ultraThinMaterial = Material(type: .ultraThin)

    /// A thin material effect
    @MainActor public static let thinMaterial = Material(type: .thin)

    /// A regular material effect
    @MainActor public static let regularMaterial = Material(type: .regular)

    /// A thick material effect
    @MainActor public static let thickMaterial = Material(type: .thick)

    /// An ultra-thick material effect
    @MainActor public static let ultraThickMaterial = Material(type: .ultraThick)
}
