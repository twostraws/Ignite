//
// BootstrapConstants.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct Bootstrap {
    enum Breakpoints {
        static let small: LengthUnit = .px(576)
        static let medium: LengthUnit = .px(768)
        static let large: LengthUnit = .px(992)
        static let xLarge: LengthUnit = .px(1200)
        static let xxLarge: LengthUnit = .px(1400)
    }

    enum Containers {
        static let small: LengthUnit = .px(540)
        static let medium: LengthUnit = .px(720)
        static let large: LengthUnit = .px(960)
        static let xLarge: LengthUnit = .px(1140)
        static let xxLarge: LengthUnit = .px(1320)
    }
}
