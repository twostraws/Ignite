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

        public var description: String { rawValue }

        /// The Bootstrap CSS variable that defines this style's font size
        var sizeVariable: String {
            switch self {
            case .title1: "var(--bs-h1-font-size)"
            case .title2: "var(--bs-h2-font-size)"
            case .title3: "var(--bs-h3-font-size)"
            case .title4: "var(--bs-h4-font-size)"
            case .title5: "var(--bs-h5-font-size)"
            case .title6: "var(--bs-h6-font-size)"
            case .body: "var(--bs-body-font-size)"
            case .lead: "var(--bs-body-font-size-lg)"
            }
        }

        /// The Bootstrap font-size utility class for this style
        var fontSizeClass: String {
            switch self {
            case .title1: return "fs-1"
            case .title2: return "fs-2"
            case .title3: return "fs-3"
            case .title4: return "fs-4"
            case .title5: return "fs-5"
            case .title6: return "fs-6"
            case .body: return "" // Default body size doesn't need a class
            case .lead: return "lead" // Lead already has its own class
            }
        }

        /// A list of font styles that generate tags, as opposed to CSS classes.
        @MainActor
        public static let tagCases: [Style] = [
            .title1, .title2, .title3, .title4, .title5, .title6, .body
        ]

        /// Creates a new text level from a raw string value.
        /// - Parameter rawValue: The HTML tag name to convert into a text level (e.g., "h1", "p")
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
