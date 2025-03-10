//
// Font-Responsive.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension Font {
    /// Type for responsive font functionality
    public struct Responsive {
        let font: Font

        // swiftlint:disable nesting
        public enum Size {
            case responsive(
                _ xSmall: LengthUnit? = nil,
                small: LengthUnit? = nil,
                medium: LengthUnit? = nil,
                large: LengthUnit? = nil,
                xLarge: LengthUnit? = nil,
                xxLarge: LengthUnit? = nil
            )

            var values: ResponsiveValues<LengthUnit> {
                switch self {
                case let .responsive(xSmall, small, medium, large, xLarge, xxLarge):
                    ResponsiveValues(
                        xSmall,
                        small: small,
                        medium: medium,
                        large: large,
                        xLarge: xLarge,
                        xxLarge: xxLarge
                    )
                }
            }
        }
        // swiftlint:enable nesting

        /// Creates a system font with responsive sizing.
        /// - Parameter style: The semantic level of the font. Defaults to `.body`.
        /// - Parameter size: Responsive sizes for each breakpoint.
        /// - Parameter weight: The font weight to use.
        /// - Returns: A Font instance configured with responsive sizing.
        public static func system(
            _ style: Font.Style = .body,
            size: Font.Responsive.Size,
            weight: Font.Weight = .regular
        ) -> Responsive {
            Responsive(font: Font(name: nil, style: style, size: size, weight: weight))
        }

        /// Creates a custom font with the specified name and size.
        /// - Parameters:
        ///   - name: The name of the font file including its extension.
        ///   - style: The semantic level of the font. Defaults to `.body`.
        ///   - size: Responsive sizes for each breakpoint.
        ///   - weight: The weight (boldness) of the font.
        /// - Returns: A Font instance configured with the custom font.
        public static func custom(
            _ name: String,
            style: Font.Style = .body,
            size: Font.Responsive.Size,
            weight: Font.Weight = .regular
        ) -> Responsive {
            Responsive(font: Font(name: name, style: style, size: size, weight: weight))
        }
    }
}
