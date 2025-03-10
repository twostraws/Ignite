//
// String-Slug.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public extension String {
    /// A list of characters that are safe to use in URLs.
    private static let slugSafeCharacters = CharacterSet(charactersIn: """
        0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ\
        abcdefghijklmnopqrstuvwxyz-
        """)

    /// Attempts to convert a string to a URL-safe format.
    /// - Returns: The URL-safe version of the string if possible, or a
    /// simple lowercased, kebab case otherwise.
    func convertedToSlug() -> String {
        let startingPoint = self.convertedToDashCase()

        var result: String?

        if let latin = startingPoint.applyingTransform(
            StringTransform("Any-Latin; Latin-ASCII; Lower;"),
            reverse: false
        ) {
            let urlComponents = latin.components(separatedBy: String.slugSafeCharacters.inverted)
            result = urlComponents.filter { $0.isEmpty == false }.joined(separator: "-")
        }

        if let result {
            if result.isEmpty == false {
                // Replace multiple dashes with a single dash.
                return result.replacing(#/-{2,}/#, with: "-")
            }
        }

        // If we failed to get to this point, send back the best we can.
        return startingPoint
    }

    /// Takes a string in CamelCase and converts it to
    /// snake-case.
    /// - Returns: The provided string, converted to snake case.
    func convertedToDashCase() -> String {
        var result = ""

        for (index, character) in self.enumerated() {
            if character.isUppercase && index != 0 {
                result += "-"
            }

            result += String(character)
        }

        return result.lowercased()
    }
}
