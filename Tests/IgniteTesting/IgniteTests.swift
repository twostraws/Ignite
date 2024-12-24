//
// IgniteTests.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import XCTest

@testable import Ignite

// swiftlint:disable force_try
/// A base class that sets up an example publishing context for testing purposes.
@MainActor class ElementTest {
    /// A publishing context with sample values for root site tests.
    static let publishingContext = try! PublishingContext(
        for: TestSite(), from: #filePath)
    /// A publishing context with sample values for subsite tests.
    static let publishingSubsiteContext = try! PublishingContext(
        for: TestSubsite(), from: #filePath)

    public static func normalizeHTML(_ html: String) -> String {
        // Function to sort attributes within a tag
        func sortAttributes(in attributes: String) -> String {
            // Match key="value" pairs
            let regex = try! NSRegularExpression(
                pattern: "(\\w+)=\"([^\"]*)\"", options: [])
            let nsAttributes = attributes as NSString
            let matches = regex.matches(
                in: attributes, options: [],
                range: NSRange(location: 0, length: nsAttributes.length))

            var attributesArray: [String] = []
            for match in matches {
                let keyRange = match.range(at: 1)
                let valueRange = match.range(at: 2)
                let key = nsAttributes.substring(with: keyRange)
                let value = nsAttributes.substring(with: valueRange)
                attributesArray.append("\(key)=\"\(value)\"")
            }

            // Sort attributes alphabetically by key
            attributesArray.sort { $0.lowercased() < $1.lowercased() }
            return attributesArray.joined(separator: " ")
        }

        // Regex to find all HTML tags (both self-closing and standard)
        let tagRegex = try! NSRegularExpression(
            pattern: "<(\\w+)(\\s+[^>]*?)(/?)>", options: [])
        let nsString = html as NSString
        let matches = tagRegex.matches(
            in: html, options: [],
            range: NSRange(location: 0, length: nsString.length))

        var normalizedHTML = html
        // Iterate in reverse to avoid messing up ranges when replacing
        for match in matches.reversed() {
            let fullTagRange = match.range(at: 0)
            let tagName = nsString.substring(with: match.range(at: 1))
            let attributesString = nsString.substring(with: match.range(at: 2))
            let selfClosingSlash = nsString.substring(with: match.range(at: 3))

            let sortedAttributes = sortAttributes(in: attributesString)

            // Reconstruct the tag with sorted attributes
            let normalizedTag: String
            if sortedAttributes.isEmpty {
                normalizedTag = "<\(tagName)\(selfClosingSlash)>"
            } else {
                // Add a space before attributes if they exist
                normalizedTag =
                    "<\(tagName) \(sortedAttributes)\(selfClosingSlash)>"
            }

            // Replace the original tag with the normalized tag
            normalizedHTML = (normalizedHTML as NSString).replacingCharacters(
                in: fullTagRange, with: normalizedTag)
        }

        normalizedHTML = normalizedHTML.replacingOccurrences(
            of: " / ", with: " ", options: .regularExpression)

        return normalizedHTML
    }

}
// swiftlint:enable force_try
