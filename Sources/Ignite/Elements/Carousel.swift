//
// Carousel.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A collection of slides the user can swipe through.
public struct Carousel<Slides: CarouselElement>: HTML {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// An automatically-generated unique identifier for this carousel.
    /// Used to tell its buttons which carousel they are controlling.
    private let carouselID = "carousel\(UUID().uuidString.truncatedHash)"

    /// The collection of slides to show inside this carousel.
    private var slides: CarouselSubviewsCollection

    /// The animation style used to move between slides.
    private var style: CarouselStyle = .move

    /// The amount of time, in seconds, a slide is shown before the next appears.
    private var duration: Double?

    /// A computed property that determines if the carousel uses crossfade transitions.
    private var doesCrossfade: Bool {
        if case .crossfade = style {
            true
        } else {
            false
        }
    }

    /// Creates a new carousel from an element builder that generates slides.
    /// - Parameter items: An element builder that returns an array of
    ///   slides to place in this carousel.
    public init(@CarouselElementBuilder slides: () -> Slides) {
        self.slides = slides().subviews()
    }

    /// Creates a new carousel from a collection of items, along with a function that converts
    /// a single object from the collection into a `Slide`.
    /// - Parameters:
    ///   - items: A sequence of items you want to convert into slides.
    ///   - content: A function that accepts a single value from the sequence, and
    ///     returns a slide representing that value in the carousel.
    public init<T, S: Sequence, SlideContent: CarouselElement>(
        _ items: S,
        @CarouselElementBuilder slides: @escaping (T) -> SlideContent
    ) where S.Element == T, Slides == ForEach<[T], SlideContent> {
        let items = items.map(slides)
        self.slides = CarouselSubviewsCollection(items.map(CarouselSubview.init))
    }

    /// Adjusts the style of this carousel.
    /// - Parameter style: The new style.
    /// - Returns: A new `Carousel` instance with the updated style.
    public func carouselStyle(_ style: CarouselStyle) -> Self {
        var copy = self
        copy.style = style
        return copy
    }

    /// Sets the display duration for each slide in the carousel.
    /// - Parameter duration: The amount of time, in seconds, each slide will be displayed before advancing.
    /// - Returns: A modified carousel with the updated slide duration.
    public func slideDuration(_ duration: Double) -> Carousel {
        var copy = self
        copy.duration = duration
        return copy
    }

    /// Creates a transition style definition based on the specified carousel style.
    /// - Parameter style: The carousel style that determines the transition properties.
    /// - Returns: An inline style for the transition, or `nil` for default styles.
    private func slideTransition(for style: CarouselStyle) -> InlineStyle? {
        switch style {
        case .move(let duration, let curve) where style != .move:
            let transformTransition = "transform \(duration)s \(curve.css)"
            return .init(.transition, value: transformTransition)
        case .crossfade(let duration, let curve) where style != .crossfade:
            let transformTransition = "transform \(duration)s \(curve.css)"
            let opacityTransition = "opacity \(duration)s \(curve.css)"
            return .init(.transition, value: "\(transformTransition), \(opacityTransition)")
        default:
            return nil
        }
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        Section {
            Section {
                ForEach(0 ..< slides.elements.count) { index in
                    Button()
                        .data("bs-target", "#\(carouselID)")
                        .data("bs-slide-to", String(index))
                        .class(index == 0 ? "active" : nil)
                        .aria(.current, index == 0 ? "true" : nil)
                        .aria(.label, "Slide \(index + 1)")
                }
            }
            .class("carousel-indicators")

            Section {
                ForEach(slides.enumerated()) { index, item in
                    item
                        .class(index == 0 ? "active" : nil)
                        .style(slideTransition(for: style))
                }
            }
            .class("carousel-inner")

            Button {
                Span()
                    .class("carousel-control-prev-icon")
                    .aria(.hidden, "true")

                Span("Previous")
                    .class("visually-hidden")
            }
            .class("carousel-control-prev")
            .data("bs-target", "#\(carouselID)")
            .data("bs-slide", "prev")

            Button {
                Span()
                    .class("carousel-control-next-icon")
                    .aria(.hidden, "true")

                Span("Next")
                    .class("visually-hidden")
            }
            .class("carousel-control-next")
            .data("bs-target", "#\(carouselID)")
            .data("bs-slide", "next")
        }
        .attributes(attributes)
        .id(carouselID)
        .class("carousel", "slide", doesCrossfade ? "carousel-fade" : nil)
        .data("bs-ride", "carousel")
        .data("bs-interval", duration != nil ? Int(duration! * 1000).formatted() : nil)
        .render()
    }
}

private extension HTML {
    func data(_ name: String, _ value: String?) -> some HTML {
        modifier(DataModifier(name: name, value: value))
    }
}
