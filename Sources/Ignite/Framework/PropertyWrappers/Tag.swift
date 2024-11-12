//
// Tag.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A property wrapper that provides access to the current tag being rendered in a tag page.
///
/// Use the `@Tag` property wrapper in your tag page layouts to access the current tag:
/// ```swift
/// struct TagLayout: TagPage {
///     @Tag private var currentTag
///
///     var body: some HTML {
///         Article {
///             Heading(currentTag ?? "All Posts")
///             // Show articles matching the tag
///         }
///     }
/// }
/// ```
/// > Important: This property wrapper is only valid in types that conform to `TagPage`.
/// The tag context is managed automatically by the publishing system during rendering.
@MainActor
@propertyWrapper
public struct Tag {
    public var wrappedValue: String? {
        guard let tag = TagContext.current else {
            fatalError("Trying to access Tag value outside of a tag page context")
        }
        return tag
    }

    public init() {}
}
