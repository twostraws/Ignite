//
// TagLayout.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Tag layouts show all articles on your site that match a specific tag,
/// or all articles period if `tag` is nil. You get to decide what is shown
/// on those layouts by making a custom type that conforms to this protocol.
///
/// ```swift
/// struct TagLayout: TagLayout {
///     var body: some HTML {
///         Article {
///             Heading(tag ?? "All Posts")
///             // Show articles matching the tag
///         }
///     }
/// }
/// ```
@MainActor
public protocol Archive: ContentLayout {
    /// The type of HTML content this layout will generate
    associatedtype Body: HTML

    /// The main content of the layout
    @HTMLBuilder var body: Body { get }
}

extension Archive {
    /// The current tag during page generation.
    public var tag: String? {
        EnvironmentStore.current.currentTag
    }

    public var content: [Content] {
        EnvironmentStore.current.taggedContent
    }
}
