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
public protocol ArchiveLayout: LayoutContent {
    /// The page layout to use for this tag page.
    var pageLayout: any Layout { get }
}

public extension ArchiveLayout {
    /// The current tag during page generation.
    var tag: String? {
        PublishingContext.shared.environment.tag
    }

    var content: [Article] {
        PublishingContext.shared.environment.taggedContent
    }

    // Defaults to the site's main layout.
    var pageLayout: any Layout {
        PublishingContext.shared.site.layout
    }
}
