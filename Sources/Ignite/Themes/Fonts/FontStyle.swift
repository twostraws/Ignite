//
// FontStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public typealias FontStyle = Font.Style

/// Represents different text styles available in the system
public extension Font {
    enum Style: String, CaseIterable, Sendable {
        /// A primary heading style using Bootstrap's h1 size (2.5rem)
        case title1 = "h1"

        /// A secondary heading style using Bootstrap's h2 size (2rem)
        case title2 = "h2"

        /// A tertiary heading style using Bootstrap's h3 size (1.75rem)
        case title3 = "h3"

        /// A fourth-level heading style using Bootstrap's h4 size (1.5rem)
        case title4 = "h4"

        /// A fifth-level heading style using Bootstrap's h5 size (1.25rem)
        case title5 = "h5"

        /// A sixth-level heading style using Bootstrap's h6 size (1rem)
        case title6 = "h6"

        /// The default body text style using Bootstrap's base font size (1rem)
        case body = "p"

        /// A larger variant of body text using Bootstrap's large font size (1.25rem)
        case lead

        /// A small variant of body text suitable for components like footers (0.9rem)
        case footer1

        /// A smaller variant of body text suitable for components like footers (0.8rem)
        case footer2

        /// A very small variant of body text suitable for components like footers (0.75rem)
        case footer3

        /// A tiny variant of body text suitable for components like footers (0.65rem)
        case footer4

        /// A very tiny variant of body text suitable for components like footers (0.55rem)
        case footer5

        public var description: String { rawValue }

        /// The Bootstrap CSS variable that defines this style's font size
        var sizeVariable: String? {
            switch self {
            case .title1: "var(--bs-h1-font-size)"
            case .title2: "var(--bs-h2-font-size)"
            case .title3: "var(--bs-h3-font-size)"
            case .title4: "var(--bs-h4-font-size)"
            case .title5: "var(--bs-h5-font-size)"
            case .title6: "var(--bs-h6-font-size)"
            case .body: "var(--bs-body-font-size)"
            default: nil
            }
        }

        /// A list of font styles that generate CSS classes, as opposed to HTML tags.
        @MainActor
        public static let classCases: [Style] = [
            .lead, .footer1, .footer2, .footer3, .footer4, .footer5
        ]

        /// The Bootstrap font-size utility class for this style
        var fontSizeClass: String? {
            switch self {
            case .title1: "fs-1"
            case .title2: "fs-2"
            case .title3: "fs-3"
            case .title4: "fs-4"
            case .title5: "fs-5"
            case .title6: "fs-6"
            case .body: nil // Default body size doesn't need a class
            case .lead: "lead"
            case .footer1: "ig-footer1"
            case .footer2: "ig-footer2"
            case .footer3: "ig-footer3"
            case .footer4: "ig-footer4"
            case .footer5: "ig-footer5"
            }
        }
    }
}
