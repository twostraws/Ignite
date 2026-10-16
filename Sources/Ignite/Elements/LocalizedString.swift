//
// LocalizedString.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A string that is translated using your site's string catalog when it is rendered.
///
/// String literals become localized strings automatically wherever one is accepted,
/// including `Text`. Interpolated values are passed to the translation as arguments,
/// so `Text("Hello \(name)")` looks up the key `"Hello %@"`.
/// Strings stored in a `String` variable are never localized.
///
/// Strings are translated into the language of the page being rendered
/// using the catalog at `Site.localizationCatalog`.
/// Plural and device variations are not supported.
public struct LocalizedString: ExpressibleByStringInterpolation, InlineElement, Sendable {
    /// A value interpolated into a localized string.
    enum Argument: Sendable {
        case string(String)
        case integer(Int)
        case double(Double)

        /// The text this argument renders as.
        var text: String {
            switch self {
            case .string(let value): value
            case .integer(let value): String(value)
            case .double(let value): String(value)
            }
        }
    }

    /// Collects the key and arguments of an interpolated string literal.
    public struct StringInterpolation: StringInterpolationProtocol {
        var key = ""
        var arguments = [Argument]()

        public init(literalCapacity: Int, interpolationCount: Int) {}

        public mutating func appendLiteral(_ literal: String) {
            key += literal
        }

        public mutating func appendInterpolation(_ value: String) {
            key += "%@"
            arguments.append(.string(value))
        }

        public mutating func appendInterpolation<T: BinaryInteger>(_ value: T) {
            key += "%lld"
            arguments.append(.integer(Int(clamping: value)))
        }

        public mutating func appendInterpolation<T: BinaryFloatingPoint>(_ value: T) {
            key += "%lf"
            arguments.append(.double(Double(value)))
        }

        public mutating func appendInterpolation<T>(_ value: T) {
            key += "%@"
            arguments.append(.string(String(describing: value)))
        }
    }

    /// The catalog key, including format specifiers for interpolated values.
    var key: String

    /// The interpolated values, in order.
    var arguments: [Argument]

    /// The content and behavior of this HTML.
    public var body: some InlineElement { self }

    public init(stringLiteral value: String) {
        key = value
        arguments = []
    }

    public init(stringInterpolation: StringInterpolation) {
        key = stringInterpolation.key
        arguments = stringInterpolation.arguments
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func markup() -> Markup {
        let template = PublishingContext.current?.localizedString(for: key) ?? key
        return Markup(verbatim: substitutingArguments(into: template))
    }

    /// Replaces format specifiers in a translated template with this string's arguments.
    ///
    /// Supports `%@`, `%d`, `%lld`, `%f`, `%lf`, `%s`, positional forms such as `%1$@`,
    /// and `%%`. Templates without arguments are returned unchanged.
    func substitutingArguments(into template: String) -> String {
        guard !arguments.isEmpty else { return template }

        var result = ""
        var nextIndex = 0
        var characters = template[...]

        while let character = characters.popFirst() {
            guard character == "%" else {
                result.append(character)
                continue
            }

            if characters.first == "%" {
                characters.removeFirst()
                result.append("%")
                continue
            }

            var lookahead = characters
            var digits = ""
            while let digit = lookahead.first, digit.isNumber {
                digits.append(digit)
                lookahead.removeFirst()
            }

            var position: Int?
            if lookahead.first == "$", let value = Int(digits) {
                position = value - 1
                lookahead.removeFirst()
            } else {
                lookahead = characters
            }

            while let modifier = lookahead.first, "lhqzt".contains(modifier) {
                lookahead.removeFirst()
            }

            guard let conversion = lookahead.first, "@dDiuUfFeEgGs".contains(conversion) else {
                result.append("%")
                continue
            }

            lookahead.removeFirst()
            characters = lookahead

            let index = position ?? nextIndex
            if position == nil { nextIndex += 1 }

            if arguments.indices.contains(index) {
                result += arguments[index].text
            }
        }

        return result
    }
}
