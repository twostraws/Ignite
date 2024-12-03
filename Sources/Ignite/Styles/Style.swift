//
// Style.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that represents a visual style that can be applied to HTML elements
public protocol Style: Hashable, Equatable {
    /// The associated type that defines the body content of this style
    associatedtype Body: Style

    /// Optional prefix to prepend to the class name (usually nil)
    static var prefix: String? { get }

    /// The content/properties of the style, built using `StyleBuilder`
    @StyleBuilder var body: Body { get }

    /// The CSS variable name that will be used in the HTML
    var className: String { get }

    /// Unique identifier for this style type
    static var id: String { get }

    /// An optional namespace to scope the style's class name.
    var namespace: String { get }
}

public extension Style {
    /// Registers this style with the StyleManager and returns the generated class name.
    ///
    /// This method attempts to resolve the style into a concrete ResolvedStyle, registers it with the shared StyleManager,
    /// and returns the associated className that can be used in HTML elements. The registered style will be written to
    /// css/custom.min.css when the site is published.
    ///
    /// - Returns: The className string if registration was successful, nil otherwise.
    @MainActor func register() -> String? {
        if let resolvedStyle = StyleBuilder.buildBlock(body) as? ResolvedStyle {
            StyleManager.default.registerStyle(resolvedStyle)
            return resolvedStyle.className
        }
        return nil
    }
}

public extension Style {
    static var prefix: String? { nil }

    var namespace: String { "" }

    static var id: String {
        UUID().uuidString.truncatedHash
    }

    // Generates a kebab-case variable name from the type name, prefix, and namespace
    var className: String {
        let typeName = String(describing: type(of: self))
            .replacing(#/Style/#, with: "")
        let kebabCase = typeName.kebabCased()

        var parts: [String] = []

        if let prefix = Self.prefix {
            parts.append(prefix)
        }

        parts.append(kebabCase)

        if !namespace.isEmpty {
            parts.append(namespace.kebabCased())
        }

        parts.append(Self.id)

        return parts.joined(separator: "-")
    }
}

/// Helper for chaining media queries
extension Style {
    func chain(with condition: String) -> some Style {
        let resolved = (body as? ResolvedStyle)
        let baseValue = resolved?.value ?? ""
        let baseQueries = resolved?.mediaQueries ?? []

        if !baseQueries.isEmpty {
            let updatedQueries = baseQueries.map { query in
                MediaQuery(conditions: query.conditions + [condition])
            }
            return ResolvedStyle(
                value: baseValue,
                mediaQueries: updatedQueries,
                className: className
            )
        }

        return ResolvedStyle(
            value: baseValue,
            mediaQueries: [MediaQuery(conditions: [condition])],
            className: className
        )
    }
}
