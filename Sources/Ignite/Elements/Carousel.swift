//
// Carousel.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A collection of slides the user can swipe through.
public struct Carousel: BlockElement {
    /// Whether moving between slides should cause movement or a crossfade.
    public enum CarouselStyle {
        /// Slides should move.
        case move

        /// Slides should crossfade.
        case crossfade
    }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// An automatically-generated unique identifier for this carousel.
    /// Used to tell its buttons which carousel they are controlling.
    private let carouselID = "carousel\(UUID().uuidString)"

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
        Group {
            Group {
                for index in 0..<items.count {
                    Button()
                        .data("bs-target", "#\(carouselID)")
                        .data("bs-slide-to", String(index))
                        .class(index == 0 ? "active" : nil)
                        .aria("current", index == 0 ? "true" : nil)
                        .aria("label", "Slide \(index + 1)")
                }
            }
            .class("carousel-indicators")

            Group {
                for (index, item) in items.enumerated() {
                    item.assigned(at: index, in: context)
                }
            }
            .class("carousel-inner")
            .render(context: context)

            Button {
                Span()
                    .class("carousel-control-prev-icon")
                    .aria("hidden", "true")

                Span("Previous")
                    .class("visually-hidden")
            }
            .class("carousel-control-prev")
            .data("bs-target", "#\(carouselID)")
            .data("bs-slide", "prev")
            .render(context: context)

            Button {
                Span()
                    .class("carousel-control-next-icon")
                    .aria("hidden", "true")

                Span("Next")
                    .class("visually-hidden")
            }
            .class("carousel-control-next")
            .data("bs-target", "#\(carouselID)")
            .data("bs-slide", "next")
            .render(context: context)
        }
        .attributes(attributes)
        .id(carouselID)
        .class("carousel", "slide", style == .crossfade ? "carousel-fade" : nil)
        .data("bs-ride", "carousel")
        .render(context: context)
    }
}
