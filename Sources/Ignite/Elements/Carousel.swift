//
// Carousel.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A collection of slides the user can swipe through.
public struct Carousel: BlockHTML {
    /// Whether moving between slides should cause movement or a crossfade.
    public enum CarouselStyle {
        /// Slides should move.
        case move

        /// Slides should crossfade.
        case crossfade
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a grid.
    public var columnWidth = ColumnWidth.automatic

    /// An automatically-generated unique identifier for this carousel.
    /// Used to tell its buttons which carousel they are controlling.
    private let carouselID = "carousel\(UUID().uuidString.truncatedHash)"

    /// The collection of slides to show inside this carousel.
    var items: [Slide]

    /// The animation style used to move between slides.
    var style = CarouselStyle.move

    /// Creates a new carousel from an element builder that generates slides.
    /// - Parameter items: An element builder that returns an array of
    /// slides to place in this carousel.
    public init(@ElementBuilder<Slide> _ items: () -> [Slide]) {
        self.items = items()
    }

    /// Adjusts the style of this carousel.
    /// - Parameter style: The new style.
    /// - Returns: A new `Carousel` instance with the updated style.
    public func carouselStyle(_ newStyle: CarouselStyle) -> Self {
        var copy = self
        copy.style = newStyle
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        Section {
            Section {
                ForEach(0..<items.count) { index in
                    Button()
                        ._data("bs-target", "#\(carouselID)")
                        ._data("bs-slide-to", String(index))
                        ._class(index == 0 ? "active" : nil)
                        ._aria("current", index == 0 ? "true" : nil)
                        ._aria("label", "Slide \(index + 1)")
                }
            }
            ._class("carousel-indicators")

            Section {
                ForEach(items.enumerated()) { index, item in
                    item.assigned(at: index, in: context)
                }
            }
            ._class("carousel-inner")

            Button {
                Span()
                    ._class("carousel-control-prev-icon")
                    ._aria("hidden", "true")

                Span("Previous")
                    ._class("visually-hidden")
            }
            ._class("carousel-control-prev")
            ._data("bs-target", "#\(carouselID)")
            ._data("bs-slide", "prev")

            Button {
                Span()
                    ._class("carousel-control-next-icon")
                    ._aria("hidden", "true")

                Span("Next")
                    ._class("visually-hidden")
            }
            ._class("carousel-control-next")
            ._data("bs-target", "#\(carouselID)")
            ._data("bs-slide", "next")
        }
        .attributes(attributes)
        ._id(carouselID)
        ._class("carousel", "slide", style == .crossfade ? "carousel-fade" : nil)
        ._data("bs-ride", "carousel")
        .render(context: context)
    }
}
