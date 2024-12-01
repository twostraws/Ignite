//
// ElementBuilder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

typealias HeadElementBuilder = ElementBuilder<any HeadElement>
typealias RootHTMLBuilder = ElementBuilder<any RootHTML>
typealias StaticLayoutBuilder = ElementBuilder<any StaticLayout>
typealias ContentLayoutBuilder = ElementBuilder<any ContentLayout>
typealias ActionBuilder = ElementBuilder<any Action>

/// A result builder that lets us generically build arrays of some content.
@resultBuilder
public struct ElementBuilder<T> {
    /// Flattens into a one-dimensional array many arrays specified as a variadic parameter.
    /// - Parameter components: A variadic array of elements.
    /// - Returns: A one-dimensional array of elements.
    public static func buildBlock(_ components: [T]...) -> [T] {
        components.flatMap { $0 }
    }

    /// Flattens a two-dimensional array of values into into a one-dimensional array.
    /// This enables loops in our result builder.
    /// - Parameter components: An array of arrays of our type.
    /// - Returns: A one-dimensional array of our type.
    public static func buildArray(_ components: [[T]]) -> [T] {
        components.flatMap { $0 }
    }

    /// Converts a single object into an array of the same type, so we can flatten
    /// using the methods above.
    /// - Parameter expression: A single value of our type.
    /// - Returns: An array of our type, containing that single value.
    public static func buildExpression(_ expression: T) -> [T] {
        [expression]
    }

    /// Accepts an optional array of our type, either returning it if it exists, or
    /// returning an empty array otherwise.
    /// - Parameter component: An optional array of our type.
    /// - Returns: An array of our type, which may be empty.
    public static func buildOptional(_ component: [T]?) -> [T] {
        component ?? []
    }

    /// Returns its input value. Along with buildEither(second:) this enables conditions
    /// in our result builder.
    /// - Returns: The same array, unchanged.
    public static func buildEither(first component: [T]) -> [T] {
        component
    }

    /// Returns its input value. Along with buildEither(first:) this enables conditions
    /// in our result builder.
    /// - Parameter component: An array of our type.
    /// - Returns: The same array, unchanged.
    public static func buildEither(second component: [T]) -> [T] {
        component
    }
}
