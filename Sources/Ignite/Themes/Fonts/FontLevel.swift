//
// FontStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Represents different text styles available in the system
public extension Font {
    enum Style: String, CaseIterable, Sendable, LengthUnit {
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

        public var description: String { rawValue }

        /// The Bootstrap CSS variable that defines this style's font size
        var sizeVariable: String {
            switch self {
            case .title1: return "var(--bs-h1-font-size)"
            case .title2: return "var(--bs-h2-font-size)"
            case .title3: return "var(--bs-h3-font-size)"
            case .title4: return "var(--bs-h4-font-size)"
            case .title5: return "var(--bs-h5-font-size)"
            case .title6: return "var(--bs-h6-font-size)"
            case .body: return "var(--bs-body-font-size)"
            case .lead: return "var(--bs-body-font-size-lg)"
            }
        }

        /// Creates a new text level from a raw string value.
        /// - Parameter rawValue: The HTML tag name to convert into a text level (e.g., "h1", "p")
        /// - Returns: The corresponding text level, or nil if the tag name isn't valid
        public init?(rawValue: String) {
            switch rawValue.lowercased() {
            case "h1": self = .title1
            case "h2": self = .title2
            case "h3": self = .title3
            case "h4": self = .title4
            case "h5": self = .title5
            case "h6": self = .title6
            case "p": self = .body
            case "lead": self = .lead
            default: return nil
            }
        }
    }
}
