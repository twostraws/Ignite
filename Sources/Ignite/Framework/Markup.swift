//
// Markup.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A structure that represents HTML markup content.
public struct Markup: Sendable, Equatable {
    /// The raw HTML string content.
    var string: String

    /// Returns a Boolean value indicating whether the markup contains no characters.
    var isEmpty: Bool {
        return string.isEmpty
    }

    /// Creates a markup instance with the given string.
    /// - Parameter string: The string to use as HTML markup.
    init(_ string: String = "") {
        self.string = string
    }
}

extension Array where Element == Markup {
    /// Joins all Markup objects in the array into a single Markup
    /// - Parameter separator: Optional separator to place between
    /// each Markup's string (defaults to empty string)
    /// - Returns: A new Markup object with all strings joined
    func joined(separator: String = "") -> Markup {
        let joinedString = self.map { $0.string }.joined(separator: separator)
        return Markup(joinedString)
    }
}

extension Markup {
    /// Concatenates two Markup objects by combining their strings
    /// - Parameters:
    ///   - lhs: Left-hand side Markup
    ///   - rhs: Right-hand side Markup
    /// - Returns: A new Markup with the combined strings
    static func + (lhs: Markup, rhs: Markup) -> Markup {
        return Markup(lhs.string + rhs.string)
    }

    /// Allows for compound assignment (+=) with another Markup
    /// - Parameters:
    ///   - lhs: Left-hand side Markup (will be modified)
    ///   - rhs: Right-hand side Markup to add
    static func += (lhs: inout Markup, rhs: Markup) {
        lhs.string += rhs.string
    }
}
