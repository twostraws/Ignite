//
// Slide.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// One slide in a `Carousel`.
public struct Slide: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// An optional background image to use for this slide. This should be
    /// specified relative to the root of your site, e.g. /images/dog.jpg.
    var background: String?

    /// Other items to display inside this slide.
    var items: [any HTML]

    /// How opaque the background image should be. Use values lower than 1.0
    /// to progressively dim the background image.
    var backgroundOpacity = 1.0

    /// Creates a new `Slide` object using a background image.
    /// - Parameter background: An optional background image to use for
    /// this slide. This should be specified relative to the root of your
    /// site, e.g. /images/dog.jpg.
    public init(background: String) {
        self.background = background
        self.items = []
    }

    /// Creates a new `Slide` object using a background image and a page
    /// element builder that returns an array of `HTML` objects to use
    /// inside the slide.
    /// - Parameter background: An optional background image to use for
    /// this slide. This should be specified relative to the root of your
    /// site, e.g. /images/dog.jpg.
    /// - Parameter items: Other items to place inside this slide, which will
    /// be placed on top of the background image.
    public init(background: String? = nil, @HTMLBuilder items: () -> [any HTML]) {
        self.background = background
        self.items = flatUnwrap(items())
    }

    /// Adjusts the opacity of the background image for this slide. Use values
    /// lower than 1.0 to progressively dim the background image.
    /// - Parameter opacity: The new opacity for this slide.
    /// - Returns: A new `Slide` instance with the updated background opacity.
    public func backgroundOpacity(_ opacity: Double) -> Slide {
        var copy = self
        copy.backgroundOpacity = opacity
        return copy
    }

    /// Used during rendering to assign this carousel slide to a particular parent,
    /// so our open paging behavior works correctly.
    func assigned(at index: Int, in context: PublishingContext) -> String {
        Group {
            if let slideBackground = background {
                Image(slideBackground, description: "")
                    .class("d-block", "w-100")
                    .style("height: 100%", "object-fit: cover", "opacity: \(backgroundOpacity)")
            }

            Group {
                Group {
                    render(context: context)
                }
                .class("carousel-caption")
            }
            .class("container")
        }
        .class("carousel-item")
        .class(index == 0 ? "active" : nil)
        .style("background-color: black")
        .render(context: context)
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        items.map { $0.render(context: context) }.joined()
    }
}
