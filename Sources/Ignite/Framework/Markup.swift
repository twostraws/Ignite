//
// Markup.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A structure that represents HTML markup content.
public struct Markup: Sendable, ExpressibleByStringLiteral, ExpressibleByStringInterpolation {
    /// The raw HTML string content.
    var string: String

    /// Returns a Boolean value indicating whether the markup contains no characters.
    var isEmpty: Bool {
        return string.isEmpty
    }

    /// Creates an empty markup instance.
    init() {
        self.string = ""
    }

    /// Creates a markup instance from another markup value.
    /// - Parameter markup: The markup value to copy.
    init(_ markup: Markup) {
        self = markup
    }

    /// Creates a markup instance from a raw string without interpolation handling.
    /// - Parameter value: The string to use as HTML markup.
    init(verbatim value: String) {
        self.string = value
    }

    /// Creates a markup instance from a static string literal.
    /// - Parameter value: The string literal to use as HTML markup.
    public init(stringLiteral value: String) {
        self.string = value
    }

    /// Creates a markup instance from an interpolated string literal.
    /// - Parameter stringInterpolation: The accumulated interpolation state.
    public init(stringInterpolation: StringInterpolation) {
        if let context = PublishingContext.current {
            for registration in stringInterpolation.pendingRegistrations {
                registration.apply(to: context)
            }
        }
        self.string = stringInterpolation.output
    }

    /// Accumulator type used by Swift's string-interpolation machinery to build a `Markup`.
    public struct StringInterpolation: StringInterpolationProtocol {
        /// The interpolated HTML string assembled so far.
        var output: String = ""

        /// Any pending publishing-time registrations to be applied.
        var pendingRegistrations: [PublishingRegistration] = []

        /// Creates a fresh interpolation accumulator with reserved capacity for the literal segments.
        /// - Parameters:
        ///   - literalCapacity: The total length of the literal segments in the string.
        ///   - interpolationCount: The number of interpolations in the string.
        public init(literalCapacity: Int, interpolationCount: Int) {
            output.reserveCapacity(literalCapacity)
        }

        /// Appends a literal segment of the interpolated string.
        /// - Parameter literal: The literal text between interpolations.
        public mutating func appendLiteral(_ literal: String) {
            output += literal
        }

        /// Appends a set of HTML attributes and queues their publishing-time registrations.
        /// - Parameter attributes: The attributes to render and harvest from.
        public mutating func appendInterpolation(_ attributes: CoreAttributes) {
            pendingRegistrations.append(contentsOf: attributes.publishingRegistrations)
            output += attributes.description
        }

        /// Appends another markup value into the interpolation.
        /// - Parameter markup: The markup whose contents should be appended.
        public mutating func appendInterpolation(_ markup: Markup) {
            output += markup.string
        }

        /// Appends any other value by converting it to a string.
        /// - Parameter value: The value to render via `String(describing:)`.
        public mutating func appendInterpolation<T>(_ value: T) {
            output += String(describing: value)
        }
    }
}

extension Array where Element == Markup {
    /// Joins all Markup objects in the array into a single Markup
    /// - Parameter separator: Optional separator to place between
    /// each Markup's string (defaults to empty string)
    /// - Returns: A new Markup object with all strings joined
    func joined(separator: String = "") -> Markup {
        let joinedString = self.map { $0.string }.joined(separator: separator)
        return Markup(verbatim: joinedString)
    }
}

extension Markup {
    /// Concatenates two Markup objects by combining their strings
    /// - Parameters:
    ///   - lhs: Left-hand side Markup
    ///   - rhs: Right-hand side Markup
    /// - Returns: A new Markup with the combined strings
    static func + (lhs: Markup, rhs: Markup) -> Markup {
        return Markup(verbatim: lhs.string + rhs.string)
    }

    /// Allows for compound assignment (+=) with another Markup
    /// - Parameters:
    ///   - lhs: Left-hand side Markup (will be modified)
    ///   - rhs: Right-hand side Markup to add
    static func += (lhs: inout Markup, rhs: Markup) {
        lhs.string += rhs.string
    }
}
