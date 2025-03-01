//
// ResponsiveBreakpoint.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public struct Breakpoints: Hashable, Sendable {
    let xSmall: LengthUnit
    let small: LengthUnit
    let medium: LengthUnit
    let large: LengthUnit
    let xLarge: LengthUnit
    let xxLarge: LengthUnit
    let cascadeUpward: Bool

    private let xSmallDefault: LengthUnit = .px(576)
    private let smallDefault: LengthUnit = .px(576)
    private let mediumDefault: LengthUnit = .px(768)
    private let largeDefault: LengthUnit = .px(992)
    private let xLargeDefault: LengthUnit = .px(1200)
    private let xxLargeDefault: LengthUnit = .px(1400)

    // Special value indicating "use default"
    private static let defaultBreakpoint: LengthUnit = .custom("USE_DEFAULT")

    public static let `default` = Breakpoints(
        xSmall: .px(576),
        small: .px(576),
        medium: .px(768),
        large: .px(992),
        xLarge: .px(1200),
        xxLarge: .px(1400)
    )

    init(
        xSmall: LengthUnit = Self.defaultBreakpoint,
        small: LengthUnit = Self.defaultBreakpoint,
        medium: LengthUnit = Self.defaultBreakpoint,
        large: LengthUnit = Self.defaultBreakpoint,
        xLarge: LengthUnit = Self.defaultBreakpoint,
        xxLarge: LengthUnit = Self.defaultBreakpoint,
        cascade: Bool = true
    ) {
        // Helper function to get closest smaller non-default value
        func inheritValue(
            values: [(value: LengthUnit, wasExplicitlySet: Bool)],
            upTo index: Int
        ) -> LengthUnit {
            guard cascade else {
                return values[index].value
            }

            // Look for closest smaller breakpoint that was explicitly set
            for i in (0..<index).reversed() {
                let (value, wasExplicitlySet) = values[i]
                if wasExplicitlySet {
                    return value
                }
            }

            return values[index].value
        }

        // Create array of values and whether they were explicitly set
        let values: [(value: LengthUnit, wasExplicitlySet: Bool)] = [
            (xSmall == .default ? xSmallDefault : xSmall, xSmall != .default),
            (small == .default ? smallDefault : small, small != .default),
            (medium == .default ? mediumDefault : medium, medium != .default),
            (large == .default ? largeDefault : large, large != .default),
            (xLarge == .default ? xLargeDefault : xLarge, xLarge != .default),
            (xxLarge == .default ? xxLargeDefault : xxLarge, xxLarge != .default)
        ]

        // Assign final values with cascading
        self.xSmall = values[0].value
        self.small = values[1].wasExplicitlySet ? values[1].value : inheritValue(values: values, upTo: 1)
        self.medium = values[2].wasExplicitlySet ? values[2].value : inheritValue(values: values, upTo: 2)
        self.large = values[3].wasExplicitlySet ? values[3].value : inheritValue(values: values, upTo: 3)
        self.xLarge = values[4].wasExplicitlySet ? values[4].value : inheritValue(values: values, upTo: 4)
        self.xxLarge = values[5].wasExplicitlySet ? values[5].value : inheritValue(values: values, upTo: 5)
        self.cascadeUpward = cascade
    }
}

